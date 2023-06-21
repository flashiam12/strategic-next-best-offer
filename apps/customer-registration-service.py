from orms import *
from faker import Faker
from random import choice, uniform

def main():
    db = Session()
    print("Starting to create dataset for {} times".format(os.environ.get("ITERATION_COUNT")))
    try:
        for i, x in enumerate(range(0, int(os.environ.get("ITERATION_COUNT")))):
        # for x in range(0, 10):
            print("Creating dataset for {} time".format(i))
            fake = Faker()
            customer_registration = CustomerRegistration(
                FIRST_NAME = fake.first_name(),
                LAST_NAME = fake.last_name(),
                EMAIL = fake.email(),
                GENDER = choice(["MALE", "FEMALE", "OTHER"]),
                INCOME = int(uniform(1000, 1000000)),
                FICO = int(uniform(100,800))
            )
            # print("{0}:{1}".format(i, customer_registration.__dict__))
            db.add(customer_registration)
            db.commit()
    except Exception as e:
        print(e)
    finally:
        db.close()

if __name__=="__main__":
    # Base.metadata.create_all(checkfirst=True)
    print("Starting batch job to produce dataset")
    main()
    print("Gracefully exitiing...")

