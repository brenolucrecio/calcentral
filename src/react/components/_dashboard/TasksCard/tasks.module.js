export const keyForTask = (task, index, prefix) => {
  if (task.type) {
    return `${prefix}-${task.type}-${index}`;
  } else {
    return `${prefix}-${task.displayCategory}-${index}-${task.aidYear}`;
  }
};

export const completedTaskCategories = [
  {
    key: 'agreements',
    title: 'Agreements and Opt-ins',
  },
  {
    key: 'admissions',
    title: 'Admission Tasks',
  },
  {
    key: 'residency',
    title: 'Residency Tasks',
  },
  {
    key: 'financialAid',
    title: 'Finances Tasks',
  },
  {
    key: 'newStudent',
    title: 'New Student Tasks',
  },
  {
    key: 'student',
    title: 'Student Tasks',
  },
];

export const incompleteTaskCategories = [
  { key: 'overdue', title: 'Overdue' },
  {
    key: 'admissions',
    title: 'Admission Tasks',
  },
  {
    key: 'residency',
    title: 'Residency Tasks',
  },
  {
    key: 'financialAid',
    title: 'Finances Tasks',
  },
  {
    key: 'newStudent',
    title: 'New Student Tasks',
  },
  {
    key: 'student',
    title: 'Student Tasks',
  },
  {
    key: 'bCourses',
    title: 'bCourses Tasks',
  },
];

const byAirYearReducer = (accumulator, value) => {
  accumulator[value.aidYear] = accumulator[value.aidYear]
    ? [...accumulator[value.aidYear], value]
    : [value];

  return accumulator;
};

export const groupByAidYear = items => {
  return items.reduce(byAirYearReducer, {});
};

export const groupByCategory = (accumulator, value) => {
  if (value.isOverdue) {
    if (accumulator.hasOwnProperty('overdue')) {
      accumulator['overdue'].push(value);
    } else {
      accumulator['overdue'] = [value];
    }
  } else {
    if (accumulator.hasOwnProperty(value.displayCategory)) {
      accumulator[value.displayCategory].push(value);
    } else {
      accumulator[value.displayCategory] = [value];
    }
  }

  return accumulator;
};

import { isWithinInterval, parseISO, addDays, startOfToday } from 'date-fns';

export const isDueWithinWeek = task =>
  isWithinInterval(parseISO(task.dueDate), {
    start: startOfToday(),
    end: addDays(startOfToday(), 6),
  });
