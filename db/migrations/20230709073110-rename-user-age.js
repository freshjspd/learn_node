'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.renameColumn(
      "Users",
      "age",
      "userAge"
    );
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.renameColumn(
      "Users",
      "userAge",
      "age"
    )
  }
};
