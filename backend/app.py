import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import transforms, models
from flask import Flask, request, jsonify
from flask_cors import CORS
from PIL import Image
import base64, io

app = Flask(__name__)
CORS(app)

MEAN = [0.485, 0.456, 0.406]
STD  = [0.229, 0.224, 0.225]

CLASS_NAMES = [
    'Corn__Cercospora_leaf_spot Gray_leaf_spot',
    'Corn__Common_rust',
    'Corn__Northern_Leaf_Blight',
    'Corn__healthy',
]

device = torch.device('cpu')

model = models.mobilenet_v2(pretrained=False)
model.classifier = nn.Sequential(
    nn.Dropout(p=0.3),
    nn.Linear(model.last_channel, 256),
    nn.ReLU(),
    nn.Dropout(p=0.2),
    nn.Linear(256, len(CLASS_NAMES))
)

checkpoint = torch.load('maize_model_best.pth', map_location=device)
model.load_state_dict(checkpoint['model_state_dict'])
model.eval()
print('✅ Model loaded!')

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(MEAN, STD)
])

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    if not data or 'image' not in data:
        return jsonify({'error': 'No image provided'}), 400
    try:
        img_bytes = base64.b64decode(data['image'])
        img = Image.open(io.BytesIO(img_bytes)).convert('RGB')
        tensor = transform(img).unsqueeze(0).to(device)

        with torch.no_grad():
            outputs = model(tensor)
            probs = F.softmax(outputs, dim=1)[0]

        ranked = sorted(
            zip(CLASS_NAMES, probs.tolist()),
            key=lambda x: x[1], reverse=True
        )
        top_label, top_conf = ranked[0]
        return jsonify({
            'disease': top_label,
            'confidence': round(top_conf, 4),
            'alternatives': [
                {'label': l, 'confidence': round(c, 4)}
                for l, c in ranked[1:]
            ]
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)