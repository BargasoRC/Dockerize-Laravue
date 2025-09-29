Requirements:
- Docker

Development Instructions:
- Run in terminal `docker-compose build --no-cache` # make sure docker is already running
- Run in terminal `docker-compose up`
- Comment `DB_HOST` from project location .env
- Run in terminal `php artisan migrate --seed`
- Run in terminal `php artisan optimize`
- Uncomment `DB_HOST` from project location .env
- Run in terminal `npm install` # setting up of vue
- Run in terminal `npm run development`