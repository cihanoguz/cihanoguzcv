FROM ruby:2.7-slim AS base

WORKDIR /site

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential git \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:1.16.5 \
    && bundle install

FROM base AS dev

COPY . .

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--host=0.0.0.0", "--livereload", "--force_polling"]

FROM base AS builder

COPY . .

ENV JEKYLL_ENV=production
ARG INJECT_CV_DOWNLOAD_LINK=NO
ENV INJECT_CV_DOWNLOAD_LINK=${INJECT_CV_DOWNLOAD_LINK}

RUN bundle exec jekyll build

FROM nginx:1.27-alpine AS production

COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /site/_site /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
