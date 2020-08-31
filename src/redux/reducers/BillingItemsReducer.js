/* eslint camelcase: 0 */
// TODO: change API to camelcase

import { parseISO } from 'date-fns';

import {
  FETCH_BILLING_ITEMS_START,
  FETCH_BILLING_ITEMS_SUCCESS,
  FETCH_BILLING_ITEMS_FAILURE,
  FETCH_BILLING_ITEM_START,
  FETCH_BILLING_ITEM_SUCCESS,
  FETCH_BILLING_ITEM_FAILURE,
} from '../action-types';

const setDate = item => {
  if (item.due_date === null) {
    return item;
  } else {
    return { ...item, due_date: parseISO(item.due_date) };
  }
};

const updateItemDetails = (state, newItem) => {
  const items = state.items.map(item => {
    if (newItem.id === item.id) {
      return { ...item, ...newItem };
    }

    return item;
  });

  return { ...state, items };
};

const BillingItemsReducer = (state = {}, action) => {
  switch (action.type) {
    case FETCH_BILLING_ITEMS_START:
      return { ...state, isLoading: true, error: null };
    case FETCH_BILLING_ITEMS_FAILURE:
      return { ...state, isLoading: false, error: action.value };
    case FETCH_BILLING_ITEMS_SUCCESS:
      return {
        ...state,
        items: action.value.map(setDate),
        isLoading: false,
        loaded: true,
        error: null,
      };
    case FETCH_BILLING_ITEM_START:
      return updateItemDetails(state, {
        id: action.value,
        isLoadingPayments: true,
        loadingPaymentsError: null,
      });
    case FETCH_BILLING_ITEM_SUCCESS:
      return updateItemDetails(state, {
        ...action.value,
        isLoadingPayments: false,
        loadedPayments: true,
        loadingPaymentsError: null,
      });
    case FETCH_BILLING_ITEM_FAILURE:
      return updateItemDetails(state, {
        ...state.items.find(item => item.id === action.id),
        isLoadingPayments: false,
        loadingPaymentsError: action.value,
      });
    default:
      return state;
  }
};

export default BillingItemsReducer;
