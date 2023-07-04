const ejs = require("ejs");
const path = require("path");
// eslint-disable-next-line no-undef
const ejsPath = path.join(__dirname, "..", "views/partials/task.ejs");

class Task {
  constructor(task) {
    this.id = task.id;
    this.title = task.title;
    this.content = task.content;
    this.start = task.start;
    this.createdDate = task.created;
    this.done = task.done;
    this._start_ = task.start;
  }

  get start() {
    return this.startDate;
  }
  set start(startdate) {
    this.startDate = this.convertToMysqlDateTime(startdate);
  }
  get created() {
    return this.getCreated();
  }

  set created(dateStr) {
    this.createdDate = dateStr;
  }

  getCreated() {
    const today = new Date();
    const date = new Date(this.createdDate);
    const timeDiff = Math.floor((today - date) / 1000);

    const units = ["year", "month", "week", "day", "hour", "minute", "second"];
    const durations = [
      365.25 * 24 * 60 * 60,
      30.44 * 24 * 60 * 60,
      7 * 24 * 60 * 60,
      24 * 60 * 60,
      60 * 60,
      60,
      1,
    ];

    for (let i = 0; i < units.length; i++) {
      const value = Math.floor(timeDiff / durations[i]);

      if (value > 0) {
        return value === 1 ? `1 ${units[i]} ago` : `${value} ${units[i]}s ago`;
      }
    }

    return "Just now";
  }
  convertToMysqlDateTime(dateStr) {
    const date = new Date(dateStr);
    const year = date.getFullYear().toString().slice(-2);
    const month = (date.getMonth() + 1).toString().padStart(2, "0");
    const day = date.getDate().toString().padStart(2, "0");
    const hours = date.getHours().toString().padStart(2, "0");
    const minutes = date.getMinutes().toString().padStart(2, "0");

    return `${day}/${month}/${year} ${hours}:${minutes}`;
  }

  async toHtml() {
    try {
      const html = await ejs.renderFile(ejsPath, { task: this });
      return html;
    } catch (err) {
      console.error(err);
      return "";
    }
  }
}

class Tasks {
  constructor(tasks) {
    this.tasks = tasks.map((task) => new Task(task));
  }

  async toHtml() {
    const htmlArray = await Promise.all(
      this.tasks.map(async (task) => {
        return await task.toHtml();
      })
    );

    const accordionHtml = htmlArray.join("");

    const wrappedHtml = `${accordionHtml}`;

    return wrappedHtml;
  }
}

module.exports = { Tasks, Task };
