const fs = require("fs");
const path = require("path");

const NGINX_CONF_FILEPATH = path.resolve("/etc/nginx/nginx.conf");
const NGINX_MIME_TYPES_FILEPATH = path.resolve("/etc/nginx/mime.types");

const mimeTypes = Array.from(
  new Set(
    fs.readFileSync(NGINX_MIME_TYPES_FILEPATH, "utf-8").match(/\S+\/\S+/gm)
  )
);
const updatedNginxConf = fs
  .readFileSync(NGINX_CONF_FILEPATH, "utf-8")
  .replace(/.*gzip_types.*/gm, `\tgzip_types ${mimeTypes.join(" ")};`);
fs.writeFileSync(NGINX_CONF_FILEPATH, updatedNginxConf);
