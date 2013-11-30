angular.module('designcritProjectService', []).factory 'ProjectService', [->
  client: null,
  project: null
  pages: null
  selectedPage: null
  selectedCrit: null
  hoveredCrit: null
]
