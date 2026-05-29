# 1. استخدام نسخة فلاتر مستقرة وجاهزة مسبقاً (لتجاوز كل أخطاء التثبيت)
FROM ghcr.io/cirruslabs/flutter:stable

# 2. إعداد مسار العمل الأساسي
WORKDIR /app

# 3. تفعيل بيئة الويب فقط
RUN flutter config --enable-web

# 4. التبديل لصلاحيات المدير مؤقتاً لتثبيت خادم Node.js
USER root
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# 5. نسخ ملفات مشروعنا (Node.js) إلى السيرفر
COPY package*.json ./
RUN npm install
COPY . .

# 6. فتح المنفذ وتشغيل محرك التجميع
EXPOSE 3000
CMD ["npm", "start"]
