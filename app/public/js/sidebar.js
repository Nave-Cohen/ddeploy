const $sidebar = $(".sidebar");
const $searchInput = $("#search-input");
const $menuIcon = $("#menu-icon");
const $listItems = $(".list-item:not(.user)");
const $logoutItem = $(".logout-btn");
const title = document.title.toLowerCase();

getBadges();

$(".item-text").each(function () {
  var text = $(this).text().toLowerCase();
  if (text.includes(title)) {
    $(this).closest(".list-item").addClass("active");
  } else {
    $(this).closest(".list-item").removeClass("active");
  }
});

$searchInput.on("focus", function () {
  $sidebar.addClass("on-search");
});

$searchInput.on("focusout", function () {
  $sidebar.removeClass("on-search");
});

$menuIcon.on("click", function () {
  $sidebar.toggleClass("close");
  $menuIcon.toggleClass("fa-xmark fa-bars");
});

$logoutItem.on("click", function () {
  window.location.href = "/users/logout";
});

$listItems.on("click", function () {
  const url = $(this).find("medium").text();
  window.location.href = "/tasks/" + url;
});
function getBadges() {
  const cookie = $.cookie("badges") === "true";
  const todayBadgeElement = $("#today-badge");
  const upcomingBadgeElement = $("#upcoming-badge");

  let todayBadge = parseInt(todayBadgeElement.text(), 10);
  let upcomingBadge = parseInt(upcomingBadgeElement.text(), 10);
  if ($.cookie("badges")) {
    if (cookie) {
      todayBadge++;
      upcomingBadge++;
    } else {
      todayBadge--;
      upcomingBadge--;
    }
    todayBadgeElement.text(todayBadge);
    upcomingBadgeElement.text(upcomingBadge);
    $.removeCookie("badges");

  }
  todayBadgeElement.text(todayBadge);
  upcomingBadgeElement.text(upcomingBadge);

  $.removeCookie("badges");
}

setInterval(getBadges, 500);

// eslint-disable-next-line no-unused-vars
function search(items) {
  $searchInput.on("input", function () {
    var inputValue = $(this).val().toLowerCase();
    items.each(function () {
      if (
        !$(this).data("title").toLowerCase().includes(inputValue) &&
        !$(this).find(".card-text").text().toLowerCase().includes(inputValue)
      ) {
        $(this).hide();
      } else {
        $(this).show();
      }
    });
  });
}
