from flask import Flask, request, jsonify
import csv
import re

app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload():
    data = request.get_json()
    file_contents = data.get('fileContents', '')
    # Open the file in write mode
    file_path = 'csv_files/letter_c.csv'  # Provide the path to your file
    with open(file_path, 'w') as file:
        writer = csv.writer(file)
        headers = ["gyro-x", "gyro-y", "gyro-z", "accel-x", "accel-y", "accel-z"]
        #writer.writerow(headers)

        # Write content to the file
        
        values = file_contents.split(',')
        
        

        row = []
        for i, value in enumerate(values):
            row.append(value)
            
            if len(row) == 6:
                if value != ' %':
                    if row[0].startswith(' a'):
                        
                        first_three = row[:3]
                        last_three = row[-3:]

                        row[:3] = last_three
                        row[-3:] = first_three
                        
                        



                    row = [''.join([char for char in word if not char.isalpha() or char == 'e']) for word in row]
                    #writer.writerow(headers)
                    writer.writerow(row)
                
                row = []
                
            if value == ' %':
                row = []

                writer.writerow([])
                writer.writerow(headers)
                
                

        
        writer.writerow([])
        #     writer.writerow(row)

        

# File is automatically closed after exiting the 'with' block

    return jsonify({'message': 'Data received'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6000) 