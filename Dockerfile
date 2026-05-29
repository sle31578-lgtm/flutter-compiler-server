# 1. استخدام صورة فلاتر مستقرة
FROM ghcr.io/cirruslabs/flutter:stable

# 2. التبديل لصلاحيات المدير لتثبيت الأدوات
USER root
RUN apt-get update && apt-get install -y curl nodejs npm

# 3. إنشاء مستخدم عادي وضبط الصلاحيات للمجلد بالكامل
RUN useradd -ms /bin/bash flutteruser
WORKDIR /home/flutteruser/app

# 4. حل مشكلة "Dubious Ownership" الشهيرة
RUN git config --global --add safe.directory /sdks/flutter
RUN git config --global --add safe.directory /home/flutteruser/flutter

# 5. تجهيز السيرفر
COPY package*.json ./
RUN npm install
COPY . .
RUN chown -R flutteruser:flutteruser /home/flutteruser/app

# 6. التبديل للمستخدم العادي
USER flutteruser

# 7. إعداد فلاتر
RUN flutter config --enable-web
RUN flutter pub get

EXPOSE 3000
CMD ["npm", "start"]
