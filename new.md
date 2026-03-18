# Admin User Flow Documentation

## Overview

This document outlines the complete **Admin** user flow for the Vehicle Investment & Management Platform. It shows exactly what the Admin sees, what they click, and how the system responds — written as though the system is already fully implemented.

The Admin is the highest‑level user with **full access and full control** over vehicles, riders, investors, payments, assignments, remittances, reports, notifications, and all system configurations.

---

## 🔐 1. Admin Login & Authentication Flow

**Page: Login Page**

- Admin opens the platform link.
- Sees form fields: **Email/Phone** and **Password**.
- Links: **Forgot Password**, **Contact Support**.

**Action:** Admin inputs credentials → clicks **Sign In**.

### System Response

- Valid credentials → Redirect to **Admin Dashboard**.
- Invalid credentials → Red toast: *"Incorrect email or password.”*
- Forgot password → Admin enters email → receives OTP or reset link.

---

## 🏠 2. Admin Dashboard Flow

**Page: Main Admin Dashboard**
The dashboard provides a high‑level snapshot of the entire business.

### Summary Cards

| Card                            | Display                                                     | On Click                       |
| ------------------------------- | ----------------------------------------------------------- | ------------------------------ |
| **Total Vehicles**              | All registered vehicles                                     | Opens Vehicle Management Page  |
| **Total Riders**                | All active riders                                           | Opens Rider Management Page    |
| **Total Investors**             | All registered investors                                    | Opens Investor Management Page |
| **Weekly Expected Income**      | Total revenue expected from all riders                      | Opens Weekly Payments Overview |
| **Total Remitted to Investors** | Total payouts completed                                     | Opens Payout Records           |
| **Pending Approvals**           | Manual receipts, assignments, withdrawals awaiting approval | Opens Approvals Page           |

### Additional Dashboard Sections

- **Graph: Income vs. Payout Trend**
- **Recent Activities Feed** (new rider registered, vehicle assigned, payment received)
- **Quick Actions Row:**
  - Add Vehicle
  - Add Rider
  - Add Investor
  - Assign Vehicle
  - Verify Manual Payment

---

## 🚗 3. Vehicle Management Flow

*Accessed by clicking ****Total Vehicles**** card or selecting ****Vehicles**** in the main menu.*

### Page: Vehicle List

Admin sees a list or grid of all vehicles with:

- Image
- Model
- Plate Number
- Status (Active, Idle, Maintenance)
- Linked Rider and Investor (if assigned)

### Actions

- **Add New Vehicle** (button)
- **Edit Vehicle**
- **Deactivate / Put in Maintenance**
- **Assign / Reassign Vehicle**
- **View Full Vehicle Details**

### Vehicle Details Page Includes

- Full vehicle bio
- Ownership (Investor)
- Current Rider
- Guarantor details
- Payment records linked to this vehicle
- Buttons: **Edit Vehicle**, **Reassign Vehicle**, **Download Report**

---

## 👤 4. Rider Management Flow

*Accessed by clicking ****Total Riders**** card or menu → Riders*

### Page: Rider List

Admin views:

- Rider name & profile
- Assigned vehicle
- Status (Active / Awaiting Assignment)
- Weekly expected payment
- Outstanding balance

### From this page Admin can:

- Add New Rider
- Edit Rider Profile
- Assign Vehicle to Rider
- Suspend Rider
- View Rider Payment History

### Rider Details Page

Shows:

- Rider info
- Guarantor details
- Assigned vehicle (if any)
- All weekly payments
- Outstanding balance
- Buttons: **Reassign Vehicle**, **Send Reminder**, **Download Rider Statement**

---

## 💼 5. Investor Management Flow

*Accessed by clicking ****Total Investors**** card or menu → Investors*

### Page: Investor List

Admin sees a **single consolidated table** containing **all investors in one place**. Each row shows:

- Name, phone, email
- Number of vehicles funded
- Return type (Fixed or Percentage)
- Total amount invested
- Total payouts done
- Quick action menu per investor — each action opens a full flow:
- **View Details** → Opens Investor Details Page → Shows profile, funded vehicles, return setup, payout history.
- **Edit Investor** → Opens Edit Investor Form → Admin updates info → Clicks Save → System updates investor profile.
- **Add Vehicle** → Opens Add Vehicle Wizard → Select vehicle or create new → Link to investor → Confirm → Vehicle added under investor.
- **Modify Returns** → Opens Return Configuration Page → Admin updates fixed amount or percentage → Saves → System recalculates future payouts.
- **View Statement** → Opens Investor Statement Page → Shows total investment, payouts, balances → Admin can Download as PDF.
- **Payout History** → Opens Payout History List → Displays all completed and pending payouts → Admin can open a payout to view full details.

### Actions

- Add New Investor
- Edit Investor
- Link Vehicle to Investor
- Modify Return Amount / Percentage
- View Investment Statement

### Investor Details Page

Displays:

- Investor profile
- All funded vehicles
- Return logic per vehicle
- Payout records
- Buttons: **Edit Investor**, **Add Vehicle to Investor**, **Download Investor Report**

---

## 🔗 6. Assignment Flow (Vehicle ↔ Rider ↔ Investor)

*Accessed via Quick Action: ****Assign Vehicle**** OR inside any Rider/Vehicle/Investor profile.*

### Page: Assignment Wizard

Step 1 — Select Vehicle → Step 2 — Select Rider → Step 3 — Select Investor → Step 4 — Confirm Details

### System Response

- Assignment created → All parties notified.
- Dashboard updates accordingly.

---

## 💳 7. Payment & Remittance Flow

*Note: Payment statuses transition in a strict sequence — **Pending → Partial (if applicable) → Approved → Completed**. Pending means a week is due but unpaid; Partial means rider submitted part‑payment; Approved means admin has verified payment or receipt; Completed means the full amount is confirmed and the week is closed.*
*Accessed via Dashboard → Weekly Expected Income card or menu → Payments*

### Page: Weekly Payments Overview

Admin sees:

- All riders
- Amount due
- Amount paid
- Status (Paid / Partial / Pending)

### Actions

- Record Manual Payment
- Approve Uploaded Receipt
- Edit Payment Record
- Mark Week as Completed

### When Admin Opens a Specific Rider Week

Shows:

- Expected payment
- Amount received
- Method
- Receipt uploaded (if any)
- Buttons: **Approve**, **Reject**, **Edit**, **Add Note**

---

## 💵 8. Investor Payout Management Flow

*Accessed via Dashboard → Total Remitted to Investors*

### Page: Payout List

Shows:

- Investor payouts (Pending / Completed)
- Payout method
- Amount

### Actions

- Approve Withdrawal Request
- Manually Record Payout
- Edit Payout Details

### When Admin Opens a Payout Request

Shows:

- Investor bank details
- Payout amount
- Button: **Approve & Mark as Paid**

System Response:

- Investor receives notification

---

## 📤 9. Manual Payment Verification Flow

*Accessed via Dashboard → Pending Approvals*

Page lists:

- Riders who uploaded receipts
- Amount claimed
- Receipt preview

### Actions

- Approve Payment
- Reject Payment
- Add Note

System Response:

- Rider notified of approval or rejection
- Dashboard recalculates weekly status

---

## 📄 10. Reports & Analytics Flow

*Accessed via menu → Reports*

Admin can generate:

- Weekly Revenue Report
- Investor Payout Report
- Vehicle Performance Report
- Rider Payment Compliance Report

### Actions

- Select Date Range / Vehicle / Rider / Investor
- Generate → Preview → Download PDF/Excel

---

## 🔔 11. Notification Management Flow

*Accessed via bell icon → Notifications*

Admin sees all system alerts including:

- New payments
- Withdrawals
- Manual receipts
- Assignment updates
- Maintenance alerts

Admin can:

- Filter notifications
- Mark as read
- Open linked record

---

## ⚙️ 12. System Settings & Configuration Flow

*Accessed via top-right profile menu → Settings*

Admin can configure:

- Return calculation logic (global defaults)
- Notification channels
- Staff accounts & permissions
- Platform branding

---

## 🆘 13. Support & Communication Flow

Admin can:

- View support tickets from riders/investors
- Respond directly
- Close tickets

---

# Investor User Flow Documentation

## Overview

This document presents the complete user flow for **Investors** on the Vehicle Investment & Management Platform. The narrative describes exactly what an investor will see, how they will interact with the platform, and the sequence of actions and responses as though the system already exists.

Investors are individuals who fund one or more vehicles under the client's management. Each investor receives calculated weekly remittances, configured by the Admin either as:

- A **fixed amount per week**, or
- A **percentage-based return** on their investment.

The Admin has full control over investor return settings and can modify them per vehicle or per investor.

---

## 🔐 1. Investor Login & Authentication Flow

**Page: Login Page**

- The investor opens the platform link.
- The page loads a login form with fields **Phone/Email** and **Password**.
- Below the button: "Forgot Password?" and "Create an Account" are visible.

**Action:** Investor enters credentials and taps **“Sign In”**.

### System Response:

- If credentials are correct → Redirect to **Investor Dashboard**.
- If incorrect → Show toast message: *“Invalid login details, please try again.”*
- If they click **Forgot Password** → A reset modal opens where they enter their registered email/phone to receive a reset link/code.

---

## 🏠 2. Investor Dashboard Flow

*Note: Dashboard figures update when new payment records are entered or approved by the Admin. They do not rely on real-time sockets or continuous background updates, ensuring the system remains lightweight and efficient.**

**Page: Investor Dashboard (Home)**
Upon successful login, the investor sees a personalized dashboard with:

### Top Summary Cards:

| Card                        | Display                          | Action on Click                 |
| --------------------------- | -------------------------------- | ------------------------------- |
| **Total Investment Value**  | Total amount investor has funded | Opens investment breakdown page |
| **Weekly Expected Returns** | Amount expected this week        | Opens return schedule page      |
| **Total Withdrawn**         | Total returns withdrawn so far   | Opens withdrawal history        |
| **Active Vehicles**         | Number of vehicles linked        | Opens vehicle list              |

### Below Summary Cards:

- A line graph labeled **Investment Growth & Returns** (showing weekly return trend)
- A notifications widget showing latest payout activities and updates.

### Investor Quick Actions (Buttons):

- **View Vehicles**
- **Check Payments/Withdrawals**
- **Download Statement**

---

## 🚗 3. My Vehicles Flow
*Accessed by clicking **Active Vehicles** card or **View Vehicles** button on the Dashboard*

**Page: My Vehicles**
Investors see a list of linked vehicles in a clean card/grid layout.
Each card shows:

- Vehicle Photo (uploaded by Admin)
- Vehicle Name/Model (e.g., "Toyota Corolla 2011")
- Status Badge: **Active / Pending / Maintenance**
- Expected Weekly Return for this vehicle

**Action:** Clicking a vehicle card opens **Vehicle Details Page**.

### Vehicle Details Page Shows:

- Full vehicle info (brand, model, plate, purchase date, etc.)
- Assigned Rider + Guarantor contact (masked by default for security)
- Expected weekly return (fixed/percentage, configured by Admin)
- Payment History linked to this vehicle
- Buttons:
  - **View Rider Profile**
  - **Download Vehicle Statement**

---

## 💰 4. Returns & Payment Tracking Flow
*Accessed by clicking the **Weekly Expected Returns** summary card OR the **Check Payments/Withdrawals** quick-action button on the Dashboard.* *(Accessed via **Weekly Expected Returns** card — not through Withdrawal button)*
*Accessed via Dashboard by clicking **Weekly Expected Returns** card or **Check Payments/Withdrawals** button*

**Page: Returns Overview**

- Shows cumulative expected return this week.
- Shows next payout date.
- Shows whether payout is **Pending**, **Processing**, or **Completed**.

### Table: Weekly Returns Breakdown

\| Week | Vehicle | Return Type (Fixed/%) | Expected Amount | Status |

**Action Option:** Investor can click a specific week to open **Detailed Return Record**, showing:

- Vehicle return logic (e.g., "₦15,000 fixed weekly" or "15% of ₦120,000 monthly proceeds")
- If paid: date paid, transaction ID, and payment method
- If unpaid: message *“Pending approval/verification”*

---

## 💵 5. Withdrawal Requests Flow
*Accessed by clicking the **Check Payments/Withdrawals** button on the Dashboard, then selecting the **Withdrawals** tab on the Payments page.*
*Accessed from Dashboard via **“Check Payments/Withdrawals”***

If payments are not automated, investors can request payouts.

**Page: Withdrawal Requests**

- Shows current wallet balance (total paid but not withdrawn)
- Button: **Request Withdrawal**

**Action:** When investor clicks the button, a modal opens:

- Select payout method (Bank Transfer / Wallet / Manual)
- Enter account details (if not saved)
- Submit Request

### System Response:

- Confirmation: *“Withdrawal request submitted successfully.”*
- Status becomes **Processing** until Admin verifies & pays.

Investor can view withdrawal history in table form.

---

## 📄 6. Reports & Statement Download Flow
*Accessed by clicking the **Download Statement** quick-action button on the Dashboard or selecting **Reports** from the left navigation menu (if present).*

**Page: Reports & Statements**
Investor can generate:

- **Investment Statement (PDF/Excel)**
- **Return/Payout History**
- **Vehicle Financial Statement**

**Action:** Investor selects report type → Pick a date range or vehicle → Click **Generate**.

### System Response:

- Preview appears in modal.
- Button appears: **Download PDF** or **Export Excel**.

---

## 🔔 7. Notification Flow
*Accessed by clicking the bell icon in the top‑right corner of the Dashboard or selecting **Notifications** from the side menu.*

Investors receive alerts for:

- Weekly returns paid
- Withdrawal processed
- Vehicle maintenance updates
- New vehicle assigned
- System messages from Admin

### Notification Page:

Shows categorized alerts with filters: *All, Returns, Vehicles, System*.

---

## 👤 8. Profile & Settings Flow

*Accessed from the top‑right user menu by clicking the profile avatar → **Profile & Settings***

Investor can update profile information:

- Phone, email, profile photo
- Bank account details for payouts
- Change password
- Enable/disable email & SMS notifications

**Action:** Investor selects an item from the settings sidebar, edits the fields, and clicks **Save Changes**.

**System Response:** A confirmation message appears: *“Profile updated successfully.”*

---




# Rider User Flow Documentation

## Overview
This document outlines the complete **Rider** user flow for the Vehicle Investment & Management Platform. It describes, step‑by‑step, exactly what a Rider sees, what they click, and how the platform responds — written as though the system is already fully implemented.

Riders are individuals assigned to drive vehicles. They are responsible for weekly remittances to the company. Payments may be made directly through the platform (via payment gateway) or manually (with Admin verification).

---

## 🔐 1. Rider Login & Authentication Flow
**Page: Login Page**
- Rider opens the platform link.
- Sees fields for **Phone Number** and **Password**.
- Links available: **Forgot Password**, **Create Account** (if allowed), or **Contact Admin**.

**Action:** Rider enters login details → clicks **Sign In**.

### System Response
- Correct details → Redirect to **Rider Dashboard**.
- Incorrect details → Red toast: *"Invalid credentials. Please try again."*
- Forgot Password → Rider enters phone/email → receives OTP or reset link.

---

## 🏠 2. Rider Dashboard Flow
**Page: Rider Dashboard (Home)**
The dashboard gives Riders a clear view of weekly obligations and vehicle status.

### Top Summary Cards
| Card | Display | Click Action |
|------|---------|--------------|
| **Weekly Amount Due** | Shows amount the rider must pay this week | Opens Payment Page |
| **Total Paid This Month** | Shows cumulative monthly payments | Opens Payment History |
| **Outstanding Balance** | Any unpaid amount | Opens Breakdown Page |
| **Assigned Vehicle** | Vehicle model/plate | Opens Vehicle Details |

### Middle Section
- **Progress Bar**: Shows payment completion for the current week (e.g., 60% paid).
- **Latest Notifications**: Payment reminders, admin messages, approvals.

### Rider Quick Actions
- **Make Payment**
- **Upload Receipt (Manual Payment)**
- **View Vehicle**
- **Payment History**

---

## 💳 3. Payment Flow (Primary Rider Activity)
*Accessed from Dashboard via the “Weekly Amount Due” card or “Make Payment” button.*

**Page: Make Payment**
The page displays:
- Current week’s amount due
- Status (Pending / Partially Paid / Completed)
- Amount previously paid (if any)
- Payment options: **Paystack**, **Flutterwave**, or **Upload Receipt**

### Action: Online Payment
Rider clicks **Pay Online** → Selects gateway → Completes payment.

### System Response
- Upon success → *"Payment received successfully"* + auto-record.
- Dashboard updates once Admin verifies (or immediate if auto-confirmed).

---

## 📤 4. Manual Payment Flow (Receipt Upload)
*Accessed from Dashboard via **Upload Receipt** button or from Payment Page.*

**Page: Upload Receipt**
Rider uploads one of the following:
- Photo of bank transfer receipt
- Screenshot of mobile transfer
- PDF of bank confirmation

Form fields:
- Amount Paid
- Date of Payment
- Upload File Button

### Action
Rider fills the fields → clicks **Submit Receipt**.

### System Response
- *"Receipt uploaded. Pending verification."*
- Payment remains "Pending" until Admin approves.

---

## 🚗 5. Vehicle Details Flow
*Accessed by clicking **Assigned Vehicle** card or “View Vehicle” button from dashboard.*

**Page: Vehicle Details**
Shows:
- Vehicle image
- Brand, model, plate number
- Vehicle ownership (Investor name masked)
- Start date of assignment
- Expected weekly remittance
- Status (Active, Maintenance, Reassignment Pending)

Buttons:
- **View Guarantor Info** (masked except for initials and phone last 4 digits)
- **Download Vehicle Summary**

---

## 📜 6. Payment History Flow
*Accessed by clicking “Total Paid This Month” card or “Payment History” quick action.*

**Page: Payment History**
The Rider sees a table:
| Week | Amount Expected | Amount Paid | Method (Online/Manual) | Status |

**Action:** Clicking a row opens **Payment Details**, showing:
- Receipt (if uploaded)
- Verification status
- Date/time paid
- Transaction ID or Admin note

---

## 🔔 7. Notifications Flow
*Accessed by clicking the bell icon or “Latest Notifications” from dashboard.*

Notifications include:
- Weekly reminders
- Payment approval updates
- Vehicle maintenance messages
- Messages or warnings from Admin

### Notification Page
Shows filters: *All, Payments, Vehicle, System*

---

## 👤 8. Profile & Settings Flow
*Accessed by clicking the rider’s profile photo → Profile & Settings.*

Rider can manage:
- Phone number & email
- Password
- Profile photo
- Preferred notification channel

### Action
Rider edits data → presses **Save Changes**.

### System Response
- *"Profile updated successfully."*

---

## 🆘 9. Support / Contact Admin Flow
*Accessed via side menu → “Help & Support”*

Page contains:
- FAQ
- Chat/Message to Admin
- Emergency contact number

Rider can submit a support ticket.

System Response:
- *"Your message has been sent. Admin will reply shortly."*

# Manager User Flow Documentation

## Overview
This document outlines the **Manager** user flow for the Vehicle Investment & Management Platform. Managers are created by the Admin (owner) and have **restricted privileges** depending on the permissions assigned to them. The flow is written as though the feature is already implemented, detailing every click and system response.

Managers can assist with day-to-day operations but cannot override owner-level controls unless privileges allow it.

---

## 🔐 1. Manager Login & Authentication Flow

**Page: Login Page**
- Manager enters Email/Phone and Password.
- If credentials are valid and the account is active → Redirect to Manager Dashboard.
- If the Manager account is disabled or awaiting activation → System shows an appropriate message.

**Forgot Password** works the same way as admin: OTP or reset link sent.

---

## 🏠 2. Manager Dashboard Flow

The Manager dashboard is similar to the Admin dashboard but with visibility limited by permissions.

### Summary Cards (Visible Based on Privileges)
- **Vehicles Under Management**
- **Active Riders**
- **Assigned Investors** (if allowed)
- **Pending Payments to Approve**
- **Pending Receipts**

### Additional Sections
- **Recent Activities Feed** (limited to allowed scope)
- **Quick Actions** (permissions-based):
  - Add Vehicle
  - Add Rider
  - Verify Manual Payment
  - Assign Vehicle (if allowed)

---

## 🚗 3. Vehicle Management Flow

Accessible if Manager has "Vehicle Management" permission.

### Page: Vehicle List
Shows only vehicles within the Manager's allowed scope.

Manager can:
- View Vehicle Details
- Edit Vehicle Info (if allowed)
- Put Vehicle in Maintenance (if allowed)
- View linked Rider & Investor
- Generate reports for vehicles they manage

**If permission is denied** → Button is disabled with tooltip: *"Permission required: Vehicle Management".*

---

## 👤 4. Rider Management Flow

Accessible if Manager has "Rider Management" permission.

### Page: Rider List
Displays:
- Rider name, profile photo
- Assigned vehicle
- Payment compliance status

Manager can:
- Add/Edit Rider (if allowed)
- Assign Vehicle (if allowed)
- Suspend Rider (if allowed)
- View Rider Payment History

---

## 💼 5. Investor Management Flow (Optional Permission)

Managers may or may not have access to investors.

If allowed, the Manager sees:

### Page: Investor List
- Only investors assigned to this Manager
- Summary table: name, phone, number of vehicles, return type

Manager can:
- View Investor Details
- View Assigned Vehicles
- View Payout History

Managers cannot:
- Modify return structure
- Approve payouts unless specifically permitted

---

## 🔗 6. Assignment Flow (Vehicle ↔ Rider)

If Manager has assignment privileges:

### Page: Assignment Wizard
Step-by-step interface:
- Step 1: Select Vehicle (from their permitted list)
- Step 2: Select Rider
- Step 3: Confirm

System validates availability.

After confirmation:
- Rider receives notification
- Admin receives audit log entry

Managers cannot assign Investors.

---

## 💳 7. Payment & Receipt Verification Flow

If Manager has payment verification privileges:

### Page: Pending Payments
- Shows weekly payments requiring verification

Manager can:
- Approve/Reject manual receipts
- Record manual payments
- Add notes for Admin

Status transitions follow the same logic as Admin:
**Pending → Partial → Approved → Completed**

Actions performed by Managers are logged for the Admin to review.

---

## 📤 8. Limited Payout Processing Flow

If granted "Investor Payout" permission:
- Manager sees only investors they manage
- Can mark payouts as "Reviewed" but **cannot** finalize payouts unless explicitly allowed

Admin receives notification of Manager review.

---

## 📄 9. Reports & Analytics

Managers can access only the reports within their privilege scope.

Examples:
- Rider Payment Compliance Report
- Vehicle Performance Report

Managers cannot access business-wide investor payout summaries unless allowed.

---

## 🔔 10. Notification Flow

Managers receive:
- Payment updates
- Rider activity alerts
- Vehicle maintenance alerts
- Assignment updates

Managers can mark notifications as read and filter by category.

---

## ⚙️ 11. Profile & Permissions View

Managers cannot edit their own permissions, but they can view:
- Assigned roles
- Privilege list
- Managed vehicles/riders/investors

---

## 🆘 12. Support & Communication
Managers can:
- View and respond to tickets assigned to them
- Escalate unresolved issues to Admin

---





