from orms import *
from faker import Faker
from random import choice, uniform, randint

def main():
    db = Session()
    rows = int(db.query(func.count(CustomerRegistration.CUSTOMER_ID)).scalar())
    print("Starting to create dataset for {} times".format(os.environ.get("ITERATION_COUNT")))
    try:
        for i, x in enumerate(range(0, int(os.environ.get("ITERATION_COUNT")))):
        # for x in range(0, 10):
            print("Creating dataset for {} time".format(i))
            fake = Faker()
            customer = db.query(CustomerRegistration).filter(CustomerRegistration.CUSTOMER_ID==randint(0, rows-1)).one()
            customer_registration = CustomerActivity(
                IP_ADDRESS = fake.ipv4(),
                ACTIVITY_TYPE = choice(["branch_visit", "deposit", "web_open", "mobile_open", "new_account"]),
                PROPENSITY_TO_BUY = 0.0,
                CUSTOMER_REGISTRATION = customer
            )
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

