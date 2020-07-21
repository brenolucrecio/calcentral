import buildDataReducer from '../build-data-reducer';

import {
  FETCH_ACTIVITIES_START,
  FETCH_ACTIVITIES_SUCCESS,
  FETCH_ACTIVITIES_FAILURE,
  FETCH_AGREEMENTS_START,
  FETCH_AGREEMENTS_SUCCESS,
  FETCH_AGREEMENTS_FAILURE,
  FETCH_BCOURSES_TODOS_START,
  FETCH_BCOURSES_TODOS_SUCCESS,
  FETCH_BCOURSES_TODOS_FAILURE,
  FETCH_CARS_DATA_START,
  FETCH_CARS_DATA_SUCCESS,
  FETCH_CARS_DATA_FAILURE,
  FETCH_CHECKLIST_ITEMS_START,
  FETCH_CHECKLIST_ITEMS_SUCCESS,
  FETCH_CHECKLIST_ITEMS_FAILURE,
  FETCH_COVID_RESPONSE_START,
  FETCH_COVID_RESPONSE_SUCCESS,
  FETCH_COVID_RESPONSE_FAILURE,
  FETCH_EFT_ENROLLMENT_START,
  FETCH_EFT_ENROLLMENT_SUCCESS,
  FETCH_EFT_ENROLLMENT_FAILURE,
  FETCH_ENROLLMENTS_START,
  FETCH_ENROLLMENTS_SUCCESS,
  FETCH_ENROLLMENTS_FAILURE,
  FETCH_FINRES_LINKS_START,
  FETCH_FINRES_LINKS_SUCCESS,
  FETCH_FINRES_LINKS_FAILURE,
  FETCH_LAW_AWARDS_START,
  FETCH_LAW_AWARDS_SUCCESS,
  FETCH_LAW_AWARDS_FAILURE,
  FETCH_LINK_START,
  FETCH_LINK_SUCCESS,
  FETCH_LINK_FAILURE,
  FETCH_MY_ACADEMICS_START,
  FETCH_MY_ACADEMICS_SUCCESS,
  FETCH_MY_ACADEMICS_FAILURE,
  FETCH_MY_UP_NEXT_START,
  FETCH_MY_UP_NEXT_SUCCESS,
  FETCH_MY_UP_NEXT_FAILURE,
  FETCH_PROFILE_START,
  FETCH_PROFILE_SUCCESS,
  FETCH_PROFILE_FAILURE,
  FETCH_REGISTRATIONS_START,
  FETCH_REGISTRATIONS_SUCCESS,
  FETCH_REGISTRATIONS_FAILURE,
  FETCH_SIR_STATUS_START,
  FETCH_SIR_STATUS_SUCCESS,
  FETCH_SIR_STATUS_FAILURE,
  FETCH_STANDINGS_START,
  FETCH_STANDINGS_SUCCESS,
  FETCH_STANDINGS_FAILURE,
  FETCH_STATUS_AND_HOLDS_START,
  FETCH_STATUS_AND_HOLDS_SUCCESS,
  FETCH_STATUS_AND_HOLDS_FAILURE,
  FETCH_STATUS_START,
  FETCH_STATUS_SUCCESS,
  FETCH_STATUS_FAILURE,
  FETCH_TRANSFER_CREDIT_START,
  FETCH_TRANSFER_CREDIT_SUCCESS,
  FETCH_TRANSFER_CREDIT_FAILURE,
  FETCH_WEB_MESSAGES_START,
  FETCH_WEB_MESSAGES_SUCCESS,
  FETCH_WEB_MESSAGES_FAILURE,
} from '../action-types';

export const ActivitiesReducer = buildDataReducer(
  FETCH_ACTIVITIES_START,
  FETCH_ACTIVITIES_SUCCESS,
  FETCH_ACTIVITIES_FAILURE
);

export const AgreementsReducer = buildDataReducer(
  FETCH_AGREEMENTS_START,
  FETCH_AGREEMENTS_SUCCESS,
  FETCH_AGREEMENTS_FAILURE
);

export const BCoursesReducer = buildDataReducer(
  FETCH_BCOURSES_TODOS_START,
  FETCH_BCOURSES_TODOS_SUCCESS,
  FETCH_BCOURSES_TODOS_FAILURE
);

export const CarsDataReducer = buildDataReducer(
  FETCH_CARS_DATA_START,
  FETCH_CARS_DATA_SUCCESS,
  FETCH_CARS_DATA_FAILURE
);

export const ChecklistItemsReducer = buildDataReducer(
  FETCH_CHECKLIST_ITEMS_START,
  FETCH_CHECKLIST_ITEMS_SUCCESS,
  FETCH_CHECKLIST_ITEMS_FAILURE
);

export const CovidResponseReducer = buildDataReducer(
  FETCH_COVID_RESPONSE_START,
  FETCH_COVID_RESPONSE_SUCCESS,
  FETCH_COVID_RESPONSE_FAILURE
);

export const EftEnrollmentReducer = buildDataReducer(
  FETCH_EFT_ENROLLMENT_START,
  FETCH_EFT_ENROLLMENT_SUCCESS,
  FETCH_EFT_ENROLLMENT_FAILURE
);

export const EnrollmentsReducer = buildDataReducer(
  FETCH_ENROLLMENTS_START,
  FETCH_ENROLLMENTS_SUCCESS,
  FETCH_ENROLLMENTS_FAILURE
);

export const FinancialResourcesLinksReducer = buildDataReducer(
  FETCH_FINRES_LINKS_START,
  FETCH_FINRES_LINKS_SUCCESS,
  FETCH_FINRES_LINKS_FAILURE
);

export const LawAwardsReducer = buildDataReducer(
  FETCH_LAW_AWARDS_START,
  FETCH_LAW_AWARDS_SUCCESS,
  FETCH_LAW_AWARDS_FAILURE
);

export const LinksReducer = buildDataReducer(
  FETCH_LINK_START,
  FETCH_LINK_SUCCESS,
  FETCH_LINK_FAILURE
);

export const MyAcademicsReducer = buildDataReducer(
  FETCH_MY_ACADEMICS_START,
  FETCH_MY_ACADEMICS_SUCCESS,
  FETCH_MY_ACADEMICS_FAILURE
);

export const MyUpNextReducer = buildDataReducer(
  FETCH_MY_UP_NEXT_START,
  FETCH_MY_UP_NEXT_SUCCESS,
  FETCH_MY_UP_NEXT_FAILURE
);

export const ProfileReducer = buildDataReducer(
  FETCH_PROFILE_START,
  FETCH_PROFILE_SUCCESS,
  FETCH_PROFILE_FAILURE
);

export const RegistrationsReducer = buildDataReducer(
  FETCH_REGISTRATIONS_START,
  FETCH_REGISTRATIONS_SUCCESS,
  FETCH_REGISTRATIONS_FAILURE
);

export const StandingsReducer = buildDataReducer(
  FETCH_STANDINGS_START,
  FETCH_STANDINGS_SUCCESS,
  FETCH_STANDINGS_FAILURE
);

export const StatusAndHoldsReducer = buildDataReducer(
  FETCH_STATUS_AND_HOLDS_START,
  FETCH_STATUS_AND_HOLDS_SUCCESS,
  FETCH_STATUS_AND_HOLDS_FAILURE
);

export const StatusReducer = buildDataReducer(
  FETCH_STATUS_START,
  FETCH_STATUS_SUCCESS,
  FETCH_STATUS_FAILURE
);

export const TransferCreditReducer = buildDataReducer(
  FETCH_TRANSFER_CREDIT_START,
  FETCH_TRANSFER_CREDIT_SUCCESS,
  FETCH_TRANSFER_CREDIT_FAILURE
);

export const WebMessagesReducer = buildDataReducer(
  FETCH_WEB_MESSAGES_START,
  FETCH_WEB_MESSAGES_SUCCESS,
  FETCH_WEB_MESSAGES_FAILURE
);

export const SirStatusReducer = buildDataReducer(
  FETCH_SIR_STATUS_START,
  FETCH_SIR_STATUS_SUCCESS,
  FETCH_SIR_STATUS_FAILURE
);
