'use strict';

var _ = require('lodash');

angular.module('calcentral.controllers').controller('GraduateDegreeProgressController', function(academicsService, degreeProgressFactory, apiService, $scope) {
  $scope.degreeProgress = {
    graduate: {
      isLoading: true
    }
  };

  var loadGraduateDegreeProgress = function() {
    degreeProgressFactory.getGraduateMilestones().then(function(response) {
      var links = _.get(response, 'data.feed.links');
      $scope.degreeProgress.graduate.links = _.isEmpty(_.compact(_.values(links))) ? undefined : links;
      $scope.degreeProgress.graduate.progresses = _.get(response, 'data.feed.degreeProgress');
      $scope.degreeProgress.graduate.errored = _.get(response, 'errored');
    }).then(function() {
      $scope.showEmptyMilestonesMessage = apiService.user.profile.academicRoles.current.grad || (apiService.user.profile.academicRoles.current.law && apiService.user.profile.academicRoles.current.lawJspJsd);
      var hasAprLink = !!$scope.degreeProgress.graduate.links;
      var hasMilestones = $scope.degreeProgress.graduate.progresses.length;
      $scope.degreeProgress.graduate.showCard = apiService.user.profile.features.csDegreeProgressGradStudent && (hasAprLink || hasMilestones || $scope.showEmptyMilestonesMessage) && !academicsService.isNonDegreeSeekingSummerVisitor(apiService.user.profile.academicRoles);
    }).finally(function() {
      $scope.degreeProgress.graduate.isLoading = false;
    });
  };

  loadGraduateDegreeProgress();
});
