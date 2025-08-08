import csv
import random

# --- 1. تعريف هياكل بيانات أكثر ثراءً وواقعية ---

DATA_STRUCTURE = {
    'High': {
        'actions': [
            "Fix critical bug in", "Resolve production issue with", "Respond immediately to",
            "Submit final version of", "Handle urgent request from",
            "Investigate critical failure of",
            "Deploy emergency patch for"
        ],
        'objects': [
            "the payment gateway", "the user authentication service", "the main database",
            "the quarterly financial report", "the legal team", "the client's server",
            "the API endpoint"
        ],
        'contexts': [
            "as it's blocking all users", "the system is down", "the deadline is today at 5 PM",
            "ASAP", "this is a top priority", "we are losing money"
        ]
    },
    'Medium': {
        'actions': [
            "Prepare presentation for", "Develop strategy for", "Review performance of",
            "Plan architecture for", "Write detailed specification for", "Finalize budget for",
            "Onboard the new"
        ],
        'objects': [
            "the upcoming board meeting", "the new marketing campaign", "the engineering team",
            "the Q4 product roadmap", "the user feedback system", "the new project",
            "team member"
        ],
        'contexts': [
            "for next week's review", "to align with all stakeholders", "before the code freeze",
            "and send it to management", "this is key for our quarterly goals"
        ]
    },
    'Low': {
        'actions': [
            "Buy", "Schedule appointment with", "Pick up", "Renew", "Organize", "Book flight for",
            "Follow up with", "Clean the"
        ],
        'objects': [
            "groceries for the week", "the dentist", "the dry cleaning", "the passport",
            "the project documents folder", "the trip to Berlin", "the client about the invoice",
            "kitchen area"
        ],
        'contexts': [
            "sometime this week", "when you have a moment", "before it expires",
            "don't forget", "as a weekly routine"
        ]
    }
}


# --- 2. دالة لتوليد مهمة واقعية ---

def generate_realistic_task(priority):
    """
    Generates a more realistic task by combining actions, objects, and contexts.
    """
    struct = DATA_STRUCTURE[priority]
    action = random.choice(struct['actions'])
    obj = random.choice(struct['objects'])

    # 50% chance to add a context to make tasks more varied
    if random.random() > 0.5:
        context = random.choice(struct['contexts'])
        return f"{action} {obj} {context}"
    else:
        return f"{action} {obj}"


# --- 3. كتابة البيانات في ملف CSV ---

def create_dataset(filename="tasks_dataset.csv", num_samples=10000):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(["task_description", "priority"])

        # Generate a balanced number of tasks for each category
        samples_per_category = num_samples // len(DATA_STRUCTURE)

        for priority in DATA_STRUCTURE.keys():
            for _ in range(samples_per_category):
                task_desc = generate_realistic_task(priority)
                writer.writerow([task_desc, priority])

    print(f"✅ Successfully generated {num_samples} realistic samples in '{filename}'")


# --- تشغيل السكربت ---
if __name__ == "__main__":
    # يمكنك تغيير هذا الرقم كما تشاء
    create_dataset(num_samples=10000)
