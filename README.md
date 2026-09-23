# Homey QA Automation Project

![Robot Framework](https://img.shields.io/badge/Robot_Framework-000000?style=for-the-badge\&logo=robotframework)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge\&logo=python\&logoColor=white)
![Selenium](https://img.shields.io/badge/Selenium-43B02A?style=for-the-badge\&logo=selenium\&logoColor=white)
![Postman](https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge\&logo=postman\&logoColor=white)
![Jira](https://img.shields.io/badge/Jira-0052CC?style=for-the-badge\&logo=jira)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge\&logo=git\&logoColor=white)

End-to-end QA project covering requirements analysis, risk-based test design, manual testing, UI and API automation, defect management and test documentation.

## Overview

This repository contains an end-to-end QA project developed as part of the **Test Academy – Software Tester** training.

The project covers the main stages of the software testing lifecycle, from requirements analysis and test design to manual execution, defect reporting, UI automation, API testing and automated test execution.

The project focuses on two business-critical user stories of the Homey vacation rental application.

---

## Application Under Test

**Homey** is a vacation rental web application that allows travelers to search for accommodations, create booking requests and manage reservations with hosts.

The tested business flows involve both traveler and host activities.

---

## Project Scope

The testing scope covers two main business flows.

### US-07 – Make a Booking Request

The testing covers:

* accommodation search;
* date selection;
* booking request creation;
* reservation verification;
* date validation;
* guest number validation;
* reservation visibility for the host;
* reserved dates validation.

### US-08 – Process a Booking Request

The testing covers:

* host reservation management;
* reservation confirmation;
* reservation refusal;
* additional fees;
* discounts;
* payment workflow;
* reservation cancellation;
* payment confirmation;
* reservation status transitions.

---

## Testing Approach

The project follows a structured QA process:

```text
Requirements analysis
        ↓
Risk-based test strategy
        ↓
Test design
        ↓
Test data preparation
        ↓
Manual test execution
        ↓
Defect reporting
        ↓
UI automation
        ↓
API investigation and testing
        ↓
API automation
        ↓
Test results and documentation
```

The testing approach combines manual and automated testing to validate both application behaviour and complete business workflows.

---

## Test Strategy

The test strategy is based on a **risk-based testing approach**.

The main focus was placed on business-critical scenarios and areas where incorrect behaviour could directly affect the booking process.

The testing included:

* functional testing;
* positive and negative scenarios;
* boundary and validation testing;
* end-to-end business workflows;
* risk-based test prioritisation;
* UI regression automation;
* API response validation;
* business behaviour validation.

The detailed strategy is documented in [`Test_strategy.md`](Test_strategy.md).

---

## Test Coverage & Results

| Area                        | Manual Testing | Automation      | Result    |
| --------------------------- | -------------- | --------------- | --------- |
| US-07 – Booking request    | ✓             | Robot Framework | Covered   |
| US-08 – Booking processing | ✓             | Robot Framework | Covered   |
| Reservation API             | ✓             | Python / pytest | Covered   |
| API negative scenarios      | ✓             | Python / pytest | Covered   |
| Regression scenarios        | ✓             | Robot Framework | Automated |

### Project Statistics

* **2 User Stories**
* **30 Manual Test Cases**
* **13 Automated UI Tests**

  * US-07: 6 tests
  * US-08: 7 tests
* **8 Automated API Scenarios**
* **1 UI Defect Identified and Reported**

The test results and execution evidence are documented in the project artifacts.

---

## Defect Management

During manual UI testing, **one defect was identified and formally reported in Jira/Xray**.

### PP-46 – Payment without host banking information

A traveler can mark a reservation as paid even when the host has not configured banking information.

The defect was reproduced, documented and reported in Jira/Xray.

**Detection:** Manual UI testing
**Area:** Payment workflow
**Defect:** PP-46

This was the only confirmed defect identified during the IHM/UI testing phase.

API findings are documented separately because they represent behaviours requiring business validation.

---

## UI Automation

The UI automation suite was developed using **Robot Framework** and **SeleniumLibrary**.

The suite contains **13 automated tests** covering the two user stories:

* **US-07:** 6 tests
* **US-08:** 7 tests

### US-07 – Make a Booking Request

The automated tests cover:

1. Booking request by a non-connected traveler
2. End-date validation
3. Number of travelers validation
4. Booking request by a connected traveler
5. Reservation creation on the host side
6. Blocking already reserved dates

### US-08 – Process a Booking Request

The automated tests cover:

1. New reservation request on the host side
2. Reservation confirmation by the host
3. Additional fees
4. Discounts
5. Reservation payment by the traveler
6. Reservation cancellation by the traveler
7. Reservation refusal by the host

### Automation Execution

The complete UI automation suite can be executed locally and through **Jenkins**.

Jenkins runs the Robot Framework suite located in:

```text
auto_test/IHM
```

Robot Framework discovers and executes the test cases contained in the US-07 and US-08 suites.

The generated execution results are stored in:

```text
results/IHM
```

Generated Robot Framework reports include:

* `report.html`
* `log.html`
* `output.xml`

### Robot Framework execution

![Robot Framework execution](image/README/1784985429949.png)

### Robot Framework report

![Robot Framework report](image/README/1786650043818.png)

---

## API Testing & Automation

The reservation API was first investigated through browser DevTools and tested with **Postman** before being automated with **Python, pytest and requests**.

The API testing focuses on reservation-related operations and validation of both technical responses and business behaviour.

### API testing covers

* reservation requests;
* booking availability validation;
* date validation;
* guest validation;
* missing data;
* invalid listing IDs;
* booking cost calculation;
* response structure and messages;
* basic response-time validation.

### API Scenarios

The automated API suite contains **8 scenarios**:

| ID     | Scenario                           |
| ------ | ---------------------------------- |
| API-01 | Successful reservation             |
| API-02 | Unavailable dates                  |
| API-03 | Invalid date range                 |
| API-04 | Equal check-in and check-out dates |
| API-05 | Booking cost calculation           |
| API-06 | Invalid number of guests           |
| API-07 | Missing check-out date             |
| API-08 | Invalid listing ID                 |

### API Tools

* Postman
* Python
* pytest
* requests
* Browser DevTools / Network

### API Automation Structure

```text
auto_test/
└── API/
    ├── api/
    │   ├── client.py
    │   └── reservation.py
    ├── tests/
    │   ├── conftest.py
    │   └── test_reservation_api.py
    ├── postman/
    │   └── Homey_API_Tests.postman_collection.json
    ├── Homey_API_Test_Cases.xlsx
    └── README.md
```

The API automation uses a reusable authenticated session and separates generic HTTP communication from Homey-specific API operations.

### API Findings

The API testing revealed behaviours requiring additional business validation.

#### API-08 – Invalid Listing ID

An invalid `listing_id` was submitted in a reservation request.

The API returns HTTP `200` with `success: true` and indicates that the reservation request is pending host confirmation.

However, no corresponding reservation is created in the host or traveler interfaces because the listing does not exist.

This creates an inconsistency between the API response and the actual business result.

The automated test therefore expects the reservation request to be rejected (`success: false`) and currently fails against the existing API behaviour.

This test is intentionally designed to detect the inconsistency rather than to reproduce the current API response.

#### API-05 – Zero-Night Booking

When check-in and check-out dates are identical, the booking cost response can contain a zero-night calculation while still returning a positive total.

This behaviour was documented as an edge case requiring confirmation against the expected business rule.

These API observations are documented separately from the confirmed UI defect.

### Postman Collection

![Postman collection](image/README/1784985451081.png)

---

## Test Management & Documentation

Test activities and results were managed and documented using **Jira/Xray, Excel and Markdown**.

The project includes:

* test planning;
* test strategy;
* requirements analysis;
* manual test cases;
* test execution results;
* defect documentation;
* UI automation;
* API test cases;
* Postman collection;
* Python API tests.

### Main QA Documents

* [`Test_plan.md`](Test_plan.md)
* [`Test_strategy.md`](Test_strategy.md)
* [`manual_test/Test Summary Report.md`](<manual_test/Test%20Summary%20Report.md>)
* [`auto_test/API/README.md`](auto_test/API/README.md)

---

## Project Structure

```text
├── README.md
├── Jenkinsfile
├── Test_plan.md
├── Test_strategy.md
│
├── auto_test/
│   ├── tests_ihm.bat
│   │
│   ├── IHM/
│   │   ├── US-07/
│   │   └── US-08/
│   │
│   └── API/
│       ├── api/
│       │   ├── client.py
│       │   └── reservation.py
│       ├── tests/
│       │   ├── conftest.py
│       │   └── test_reservation_api.py
│       ├── postman/
│       │   └── Homey_API_Tests.postman_collection.json
│       ├── Homey_API_Test_Cases.xlsx
│       └── README.md
│
├── results/
│   └── IHM/
│       ├── log.html
│       ├── output.xml
│       └── report.html
│
├── image/
│   └── README/
│
└── manual_test/
    ├── Test Summary Report.md
    ├── analysis/
    │   ├── US-07.md
    │   └── US-08.md
    ├── design/
    │   ├── US-07_TestCases.xlsx
    │   └── US-08_TestCases.xlsx
    ├── implementation/
    │   ├── US-07/
    │   └── US-08/
    ├── execution/
    │   └── Execution_Report.xlsx
    └── bugs/
        └── PP-46
```

---

## Tools & Technologies

| Category        | Technologies                      |
| --------------- | --------------------------------- |
| Test Management | Jira, Xray                        |
| UI Automation   | Robot Framework, SeleniumLibrary  |
| API Testing     | Postman, Python, pytest, requests |
| Programming     | Python                            |
| Manual Testing  | Browser DevTools / Network        |
| Documentation   | Markdown, Excel                   |
| Version Control | Git, GitHub                       |
| CI/CD           | Jenkins                           |

---

## Future Improvements

### Jenkins Integration for API and UI Automation

The current Jenkins setup executes the IHM/UI automated tests.

The next step is to integrate the API automated tests into the existing Jenkins pipeline so that UI and API tests can be executed as part of the same automated workflow.

### Unit Testing

Add a small number of unit tests for selected Python components of the API automation.

The goal is to demonstrate testing at different levels rather than simply increasing the number of tests.

---

## Key Takeaways

This project demonstrates an end-to-end QA approach combining:

* requirements analysis and risk-based test design;
* manual functional testing;
* test case design and execution;
* Jira/Xray test management;
* defect reporting;
* Robot Framework and Selenium UI automation;
* API investigation with DevTools and Postman;
* API automation with Python, pytest and requests;
* automated execution with Jenkins;
* structured QA documentation.

The project focuses on validating business-critical booking workflows and demonstrates how manual testing findings can guide automation and further API investigation.

---

## Author

**Inna Pykhtina**

QA / Software Tester

🎓 ISTQB® CTFL v4 Certified

### Skills

* Manual Testing
* Robot Framework
* SeleniumLibrary
* Python
* pytest
* requests
* Postman
* Jira / Xray
* Jenkins
* Git & GitHub
