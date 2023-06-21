from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Float, Text, DateTime, func
import datetime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

import os

# SQLALCHEMY_DATABASE_URL = "postgresql+psycopg2://loanService:7pSTGNKpVyqEI8pU@checkride-team4-app-db.cndsjke6xo5r.us-west-2.rds.amazonaws.com/loanServiceDB"

SQLALCHEMY_DATABASE_URL = "postgresql+psycopg2://{0}:{1}@{2}:{3}/{4}".format(os.environ.get("DB_USER"), os.environ.get("DB_PASS"), os.environ.get("DB_URI"), os.environ.get("DB_PORT"), os.environ.get("DB_NAME"))

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={}
)

Session = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base(bind=engine)

class CustomerRegistration(Base):
    __tablename__ = "customer_registration"

    CUSTOMER_ID = Column(Integer, primary_key=True, autoincrement=True)
    FIRST_NAME = Column(String, unique=False, index=False, nullable=False)
    LAST_NAME = Column(String, unique=False, index=False, nullable=False)
    EMAIL = Column(String, default="", unique=False, index=True)
    GENDER = Column(String, default="MALE", unique=False, index=True)
    INCOME = Column(Integer, default=0, unique=False, index=True)
    FICO = Column(Integer, default=0, unique=False, index=True)
    CREATED_AT = Column(DateTime(timezone=True), nullable=False,
                  server_default=func.now())

    CUSTOMER_ACTIVITY = relationship("CustomerActivity", back_populates="CUSTOMER_REGISTRATION")


class CustomerActivity(Base):
    __tablename__="customer_activity"

    ACTIVITY_ID = Column(Integer, primary_key=True, index=True, autoincrement=True)
    IP_ADDRESS = Column(String, unique=False, nullable=False)
    ACTIVITY_TYPE = Column(String, unique=False, nullable=False)
    PROPENSITY_TO_BUY = Column(Float, unique=False, default=0.0)
    CUSTOMER_ID = Column(Integer, ForeignKey("customer_registration.CUSTOMER_ID"))

    CUSTOMER_REGISTRATION = relationship("CustomerRegistration", back_populates="CUSTOMER_ACTIVITY")


Base.metadata.create_all(checkfirst=True)