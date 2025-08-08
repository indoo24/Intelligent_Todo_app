from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)

# تحميل النموذج والـ Vectorizer
with open("task_priority_model.pkl", "rb") as f:
    model = joblib.load(f)

with open("vectorizer.pkl", "rb") as f:
    vectorizer = joblib.load(f)


@app.route('/classify', methods=['POST'])
def classify():
    try:
        data = request.get_json(force=True)
        if not data:
            return jsonify({'error': 'No data provided'}), 400

        tasks = data.get('tasks', [])

        # ❗ تحويل المهام إلى تمثيل عددي باستخدام الـ vectorizer
        X = vectorizer.transform(tasks)

        # ❗ توقع الأولويات بناءً على التمثيل العددي
        predictions = model.predict(X)

        results = []
        for task, priority in zip(tasks, predictions):
            results.append({'task': task, 'priority': priority})

        return jsonify(results)

    except Exception as e:
        return jsonify({'error': str(e)}), 400


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
