//
//  VCLiterals.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 27/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

enum VCLiteral: String {
    case FACEBOOK
//    case GOOGLE
    case REGSITER_CAT_TERMS_ALERT
    case LOGIN_USING_EMAIL
    case LOGIN_USING_MOBILE
    case SIGNUP_USING_EMAIL
    case SIGNUP_USING_PHONE
    case NEW_USER
    case APP_DESC
    case TERMS_AGREED
    case SIGNUP
    case SIGNUP_CONNECT_CARE
    case LOGIN_EMAIL_DESC
    case EMAIL_PLACEHOLDER
    case PSW_PLACEHOLDER
    case FORGOT_PASSWORD
    case NO_ACCOUNT
    case MOBILE_PACEHOLDER
    case LOGIN_USING_MOBILE_DESC
    case NAME_PLACEHOLDER
    case DOB_PLACEHOLDER
    case ReEnterPsw_PLACEHOLDER
    case BIO_PLACEHOLDER
    case ALREADY_REGISTER
    case LOGIN
    case SIGNUP_WITH
    case BY_SIGNING_UP
    case BY_CONTNUE
    case TERMS
    case AND
    case PRIVACY
    case VERIFICATION
//    case VERIFICATION_DESC
    case CODESENT
    case CODE_NOT_RECEIVED
    case RESEND_CODE
    case CANCEL
    case Cancel
    case OK
    case NAME_PREFIX_MR
    case NAME_PREFIX_MRS
    case NAME_PREFIX_DR
    case NAME_PREFIX_MISS
    case UPLOAD_ERROR
    case RETRY_SMALL
    case RETRY
    case JOINCONSULTANTS
    case CATEGORY_VC_TITLE
    case CATEGORY_VC_SUBTITLE
    case SUBCATEGORY_TITLE
    case DONE
    case SET_PREFERENCES_TITLE
    case SET_PREFERENCES_VALIDATION_ALERT_MULTI
    case SET_PREFERENCES_VALIDATION_ALERT_SINGLE
    case SERVICE_TYPE_TITLE
    case NEXT
    case CONSULTATION_FEE
    case FOR_UNIT
    case FIXED_PRICE
    case PRICE_RANGE
    case ADD_AVAILABILITY
    case MANAGE_AVAILABILITY
    case EDIT_AVAILABILITY
    case SELECT_AVAILABILITY
    case WEEK_DAYS
    case SELECT_DATE
    case NEW_INTERVAL
    case FROM
    case TO
    case ALL_WEEKDAYS
    case FOR_DATE
    case FOR_DAY
    case SAVE
    case SUN
    case MON
    case TUE
    case WED
    case THU
    case FRI
    case SAT
    case NEW_INTERVAL_ALERT
    case SLOT_ALERT_SAVE
    case SERVICE_ALERT
    case NA
    case WALLET
    case AVAILABLE_BALANCE
    case TRANSACTION_HISTORY
    case PAYOUT
    case WALLET_NO_DATA
    case WALLET_NO_DATA_DESC
    case RECEIVED_FROM
    case INPROGRESS
    case REACHED
    case ACCEPT
    case ACCEPT_REQUEST
    case COMPLETE
    case NO_ANSWER
    case BUSY
    case FAILED
    case NEW
    case ALL
    case REQUESTS
    case CANCELLED
    case STARTED
    case NO_REQUESTS
    case START
    case ACCEPT_TITLE
    case TRACK_STATUS
    case ACCEP_REQUEST_ALERT_DESC
    case START_REQUEST
    case START_REQUEST_ALERT_DESC
    case CANCEL_SERVICE
    case START_SERVICE
    case REACHED_DEST_TITLE
    case CHAT
    case CLASSES
    case NOTIFICATIONS
    case INVITE_PEOPLE
    case CONTACT_US
    case TERMS_AND_CONDITIONS
    case ABOUT
    case LOGOUT
    case AGE
    case PROFILE
    case VERSION
    case VERSION_INFO
    case LOGOUT_ALERT_MESSAGE
    case CANCEL_REQUEST
    case CANCEL_REQUEST_ALERT_MESSAGE
    case PHOTO
    case CHAT_THREAD_TIME
    case END_CHAT
    case END_CHAT_MESSAGE
    case CHAT_INITIAL_MESSAGE
    case CANT_SEND_MESSAGE
    case EDIT_CAPS
    case CLIENTS_TITLE
    case EXPERIENCE
    case REVIEWS
    case REVIEW
    case MANAGE_AVAIL
    case MANAGE_DOCUMENTS
    case LOGS
    case CHANGE_ADDRESS
    case CHANEG_PASSWORD = "Change Password"
    case ACCOUNT_DETAILS
    case MANAGE_PREFE
    case UPDATE_CAT
    case YR_EXP
    case YRS_EXP
    case PHONE_NUMBER
    case EDIT_PROFILE
    case NO_CLASSES_DATA
    case NO_CLASSES_DATA_DESC
    case CLASS_CATEGORY
    case USER_JOINED
    case START_CLASS
    case COMPLETE_CLASS
    case START_CLASS_ALERT
    case COMPLETE_CLASS_ALERT
    case ADD_NEW
    case ADD_CLASS
    case SELECT_CATEGORY
    case CLASS_NAME
    case SELECT_TIME
    case PRICE_OF_CLASS
    case NETWORK_ERROR
    case NO_REQUESTS_DESC
    case ACCOUNT_NOT_APPROVED
    case ACCOUNT_NOT_APPROVED_DESC
    case REVENUE
    case APPOINTMENTS
    case COMPLTED_APPTS
    case FAILED_APPTS
    case TOTAL_REVENUE
    case APP_NAME
    case CALLING
    case INCOMING
    case RINGING
    case CALL_CANCELLED
    case CHAT_NO_DATA
    case CHAT_NO_DATA_DESC
    case MINUTE
    case MINUTES
    case SECOND
    case HOUR
    case HOURS
    case SECONDS
    case NOTIFICATION_NO_DATA
    case NOTIFICATION_NO_DATA_DESC
    case CALL
    case FORGOT_PSW_MESSAGE
    case PASSWORD_RESET_MESSAGE
    case BANK_DETAILS
    case ACCOUNT_NUMBER
    case ACCOUNT_NAME
    case IFSC_CODE
    case MONEY_SENT_TO_BANK
    case ADDED_TO_WALLET
    case BANK_NAME
    case TOTAL_SERVICES
    case ADD_MONEY
    case DEBIT_CARD
    case CREDIT_CARD
    case GPAY
    case BHIM
    case CARD_ENDING_WITH
    case PAY_AMOUNT
    case INVALID_AMOUNT
    case CARD_EXP_PLACEHOLDER
    case EDIT
    case DELETE
    case EDIT_CARD
    case INPUT_AMOUNT
    case UPDATE
    case Register
    case Registration
    case BECOME_MEMBER
    case FULL_NAME = "Full Name"
    case ADDRESS = "Address"
    case PERSONAL_PROFILE = "Personal Profile"
    case UPDATE_STATUS
    case DELETE_CARD_MESSAGE
    case ADD
    case SELECT_ALL = "Select All"
    case UPLOAD_DOCS
    case TITLE
    case DESC
    case DOC_UPLOADING_ALERT
    case ADD_ONE_DOC_ALERT
    case YOU_NEED
    case ACCOUNT_TO_CONTINUE
    case ALREADY_ACCOUNT
    case LOGIN_WITH
    case VIEW_ALL
    case ARTICLES
    case APPOINTMENT
    case BLOGS
    case POST_ARTICLE
    case POST_BLOG
    case VIEWS
    case VIEW
    case UPLOAD_BANNER
    case SUBMIT
    case FAVOURITES
    case MY_BLOGS
    case HELP_SUPPORT
    case SHARE_APP
    case SIGN_OUT
    case Availability
    case Premium_shift
    case APPROVED
    case PersoanlInterest
    case WorkEnvironment
    case Covid
    case ProvidableServices
    case CA
    case IN
    case US
    case CAD
    case INR
    case USD
    case SELECT_CURRENCY = "Select Currency"
    case SELECT_COUNTRY = "Select Country"
    case PasswordUpdateSuccess
    case NEW_PASSWORD
    case OLD_PASSWORD
    case CONFIRM_PASSWORD
    case SET_QUALIFICATION
    case CAN_SELECT
    case SHIFT_INTERESTED = "what type of shift are you interested in?"
    case VERIFICATION_PENDING_TITLE
    case VERIFICATION_PENDING_DESC
    case LOC_PERMISSION_DENIED_TITLE
    case LOC_PERMISSION_DENIED_MESSAGE
    case approved = "Approved"
    case in_progress = "In Progress"
    case declined = "Declined"
    case PROVIDABLE_SERVICES_ERROR
    case PERSONALINTEREST_ERROR
    case WORK_ENVIRONMENT_ERROR
    case ESTIMATE_TIME
    case TRANSIT_NUMBER
    case INST_NUMBER
    case REACHED_DEST_ERROR
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
