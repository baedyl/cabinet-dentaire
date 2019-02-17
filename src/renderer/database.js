var mysql = require('mysql')
var connection
var db = {
  getPool: function () {
    if (connection) return connection
    connection = mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: 'toor',
      database: 'cabinet'
    })
    return connection
  }
}
module.exports = db
