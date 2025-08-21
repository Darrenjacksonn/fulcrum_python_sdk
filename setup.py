from setuptools import setup, find_packages

with open("README.md", "r") as f:
    long_description = f.read()


setup(
    name="fulcrum-ai", 
    version="0.00.01",
    packages=find_packages(include=["fulcrum_ai", "fulcrum_ai.*"]),
    description="This is the public facing sdk for Fulcrum AI.",
    long_description=long_description,
    author="Darren Jackson",
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.10",
    install_requires=open("_requirements/prod.txt").readlines()
)
