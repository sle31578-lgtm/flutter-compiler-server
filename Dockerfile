# استخدام أوبونتو كبيئة أساسية
FROM ubuntu:20.04

# إعداد البيئة لتجنب الأسئلة التفاعلية أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive

# تثبيت المتطلبات الأساسية (Git, Curl, Unzip) و Node.js
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# تثبيت Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# تفعيل فلاتر للويب
RUN flutter config --enable-web
RUN flutter precache

# إعداد خادم Node.js الخاص بنا
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# فتح البورت وتشغيل السيرفر
EXPOSE 3000
CMD ["npm", "start"]
