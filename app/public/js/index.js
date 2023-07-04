/* eslint-disable no-unused-vars */
const $items = $("[class*='accordion-item-']");
let placeholder = false;
var $accordion = $(".accordion");
// eslint-disable-next-line no-undef
search($items); //Sidebar function.

$(document).ready(function () {
  setInterval(function () {
    if ($accordion.children().length === 0 && placeholder == false) {
      $("main").append(
        `<h1 id="task-placeholder">There is no tasks to show</h1>`
      );
      placeholder = true;
    } else if ($accordion.children().length > 0 && placeholder == true) {
      $("#task-placeholder").remove();
      placeholder = false;
    }
  }, 10);
});

$(document).ready(function () {
  let itemId = $.cookie("scroll");
  if (itemId) {
    let collapseItem = $("#collapse-" + itemId);
    collapseItem.collapse("show");
    scrollTo(collapseItem);
    $.removeCookie("scroll");
  }
});
