import fitz  # PyMuPDF
import pandas as pd

def extract_crop_and_fertilizer_info(pdf_file):
    doc = fitz.open(pdf_file)
    data = []

    for page_num in range(len(doc)):
        page = doc.load_page(page_num)
        page_text = page.get_text()

        # You'll need to define your own logic to extract crop andl fertilizer information.
        # This is a simplified example and should be customized to your specific use case.
        crop_info = None
        fertilizer_recommendation = None

        # Assuming you have some way to identify the relevant text on the page
        if "Crop:" in page_text:
            crop_info = page_text[page_text.index("Crop:") + len("Crop:"):]

        if "Fertilizer Recommendation:" in page_text:
            fertilizer_recommendation = page_text[page_text.index("Fertilizer Recommendation:") + len("Fertilizer Recommendation:"):]

        data.append({
            "Crop": crop_info.strip() if crop_info else "",
            "Fertilizer Recommendation": fertilizer_recommendation.strip() if fertilizer_recommendation else ""
        })

    return data

def create_table(data):
    df = pd.DataFrame(data)
    return df

if __name__ == "__main__":
    pdf_file = "fert-recomm.pdf"
    extracted_data = extract_crop_and_fertilizer_info(pdf_file)
    table = create_table(extracted_data)
    print(table)
