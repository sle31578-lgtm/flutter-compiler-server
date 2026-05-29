# استخدام صورة فلاتر رسمية ومستقرة
FROM ghcr.io/cirruslabs/flutter:stable

# تثبيت Node.js وتجهيز البيئة
USER root
RUN apt-get update && apt-get install -y curl nodejs npm

# إنشاء مستخدم غير إداري (Non-root user) لتشغيل فلاتر
RUN useradd -ms /bin/bash flutteruser
WORKDIR /home/flutteruser/app

# تثبيت حزم الـ Node المطلوبة
COPY package*.json ./
RUN npm install

# نسخ ملفات السيرفر
COPY . .
RUN chown -R flutteruser:flutteruser /home/flutteruser/app

# التبديل للمستخدم العادي
USER flutteruser

# تفعيل الويب وتجهيز البناء
RUN flutter config --enable-web
RUN flutter pub get

EXPOSE 3000
CMD ["npm", "start"]
