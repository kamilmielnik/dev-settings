const fs = require("fs");
const path = require("path");

const NGINX_CONF_FILEPATH = path.resolve("/etc/nginx/nginx.conf");

const updatedNginxConf = fs
  .readFileSync(NGINX_CONF_FILEPATH, "utf-8")
  .replace(/.*gzip_types.*/gm, "\tgzip_types *;");
fs.writeFileSync(NGINX_CONF_FILEPATH, updatedNginxConf);
