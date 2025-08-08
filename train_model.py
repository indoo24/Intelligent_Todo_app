import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
import joblib

print("Starting model training process...")

# --- 1. تحميل بيانات التدريب ---
try:
    # يقرأ البيانات من الملف الذي أنشأناه سابقًا
    dataset = pd.read_csv('tasks_dataset.csv')
    X = dataset['task_description']
    y = dataset['priority']
    print(f"📄 Dataset loaded with {len(dataset)} samples.")
except FileNotFoundError:
    print("❌ Error: 'tasks_dataset.csv' not found!")
    print("➡️ Please run 'generate_data.py' first to create the dataset.")
    exit()  # إيقاف السكربت إذا لم يتم العثور على البيانات

# --- 2. إنشاء وتدريب الـ Vectorizer ---
# هذا الكائن يحول النصوص إلى أرقام يستطيع النموذج فهمها
vectorizer = TfidfVectorizer()
X_vectorized = vectorizer.fit_transform(X)
print("Vectorizer has been trained.")

# --- 3. إنشاء وتدريب النموذج ---
# هذا هو النموذج الذي سيتعلم كيفية التصنيف
model = MultinomialNB()
model.fit(X_vectorized, y)
print("Model has been trained.")

# --- 4. حفظ النموذج والـ Vectorizer في ملفات ---
# هذه هي الخطوة التي تنشئ الملفات التي يحتاجها app.py
joblib.dump(model, 'task_priority_model.pkl')
joblib.dump(vectorizer, 'vectorizer.pkl')

print("\n✅ Success! Model and vectorizer have been saved as:")
print("- task_priority_model.pkl")
print("- vectorizer.pkl")
