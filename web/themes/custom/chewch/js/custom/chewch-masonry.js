// For views masonry as per: https://seanreiser.com/blog/2019/04/23/building-masonry-grid-view-bootstrap-drupal-8
jQuery(function() {
  jQuery('.views-row').masonry({
    itemSelector: '.views-row',
    percentPosition: true
  });
});
