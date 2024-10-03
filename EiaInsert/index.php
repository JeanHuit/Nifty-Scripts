<?php
// Include PhpSpreadsheet library
require 'vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;

// Database connection parameters
$servername = "";
$username = "";
$password = "";
$dbname = "";

// Create a new database connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check if the connection was successful
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Define the default password to hash
$default_password = "";

// Bcrypt the default password
// $hashed_password = password_hash($default_password, PASSWORD_BCRYPT, ['cost' => 10]);


// Load the Excel file
$inputFileName = 'eia.xlsx'; // Change this to the correct path

try {
    $spreadsheet = IOFactory::load($inputFileName);
} catch (\PhpOffice\PhpSpreadsheet\Reader\Exception $e) {
    die('Error loading file: ' . $e->getMessage());
}

// Get the first worksheet
$worksheet = $spreadsheet->getActiveSheet();

// Loop through the rows in the worksheet
foreach ($worksheet->getRowIterator() as $row) {
    $cellIterator = $row->getCellIterator();
    $cellIterator->setIterateOnlyExistingCells(false); // Loop through all cells, even if empty

    $rowData = [];
    foreach ($cellIterator as $cell) {
        $rowData[] = $cell->getValue(); // Get cell value
    }

    // Skip the header row
    if ($row->getRowIndex() == 1) {
        continue;
    }

    // Get the name and phone from the row data
    $name = $rowData[0]; // Assuming name is in the second column (A)
    $phone = $rowData[3]; // Assuming phone is in the seventh column (G)

    // Split the name into words
    $name_parts = explode(" ", trim($name));

    // Use the first word as the first name, and the last word as the last name
    $first_name = strtolower($name_parts[0]); // First name is the first word
    $last_name = strtolower(end($name_parts)); // Last name is the last word

    // Create the dummy email
    $email = $first_name . "." . $last_name . "@eia.com";

    $institution = $rowData[2];
    $role = "user";
    $password = $hashed_password;

    // Create these
    $createdAt = date('Y-m-d H:i:s');
    $updatedAt = date('Y-m-d H:i:s');


    // Prepare the SQL insert statement
    $sql = "INSERT INTO extensionsOfficers (name, email, password, createdAt, updatedAt, phone, institution, role) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    // Prepare the statement
    $stmt = $conn->prepare($sql);

    if ($stmt === false) {
        die('Prepare failed: ' . $conn->error);
    }

    // Bind the parameters to the SQL statement
    $stmt->bind_param("ssssssss", $name, $email, $hashed_password, $createdAt, $updatedAt, $phone, $institution, $role);

    // Execute the statement
    if (!$stmt->execute()) {
        echo "Error inserting row: " . $stmt->error . "\n";
    } else {
        echo "Inserted: $name\n";

    }

    // Close the statement
    $stmt->close();
}

// Close the database connection
$conn->close();

echo "Data import complete.\n";

?>
