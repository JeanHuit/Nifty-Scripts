<?php
// Database connection details
$servername = "localhost";
$username = "adminer";
$password = "#instilab13";
$dbname = "thingsboard";
$port = 3306;  // Default MySQL port

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname, $port);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Function to handle saving data
function save_data($conn) {
    $data = json_decode(file_get_contents('php://input'), true);

    $device_id = $conn->real_escape_string($data['device_id']);
    $keys = $data['key'];
    $values = $data['value'];
    $timestamp = $conn->real_escape_string($data['ts']);

    $success = true;

    for ($i = 0; $i < count($keys); $i++) {
        $key = $conn->real_escape_string($keys[$i]);
        $value = $conn->real_escape_string($values[$i]);

        $sql = "INSERT INTO TelemetryData (SensorID, `Key`, Value, TimeStamp)
                VALUES ('$device_id', '$key', '$value', '$timestamp')";

        if ($conn->query($sql) !== TRUE) {
            $success = false;
            break;
        }
    }

    return $success ? "Data saved successfully" : "Error saving data";
}

// Check if it's a POST request
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $result = save_data($conn);
    echo json_encode(["status" => $result]);
} else {
    echo json_encode(["status" => "Invalid request method"]);
}

// Close the database connection
$conn->close();
