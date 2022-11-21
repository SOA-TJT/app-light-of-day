$(document).ready(function(){
  $(".alert").fadeTo(2000,500).slideUp(500, function() {
    $(".alert").slideUp(500);
  });
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
  const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
});
