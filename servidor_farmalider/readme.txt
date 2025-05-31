
npm init -y
npm install express pg body-parser
npm install --save-dev typescript @types/node @types/express @types/pg
npx tsc --init
npm install -g nodemon
npm install -g ts-node


npx tsc


//compilar
# node dist/index.js
nodemon --exec ts-node src/index.ts
