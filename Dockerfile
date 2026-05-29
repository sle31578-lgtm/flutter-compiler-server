# استخدام أوبونتو كبيئة أساسية
FROM ubuntu:20.04

# إعداد البيئة لتجنب الأسئلة التفاعلية أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive

# تثبيت المتطلبات الأساسية
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa sudo \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# إضافة مستخدم عادي لتجنب خطأ الـ Root الذي يكرهه فلاتر
RUN useradd -ms /bin/bash flutteruser
USER flutteruser
WORKDIR /home/flutteruser

# تثبيت Flutter SDK داخل مسار المستخدم الجديد
RUN git clone https://github.com/flutter/flutter.git /home/flutteruser/flutter
ENV PATH="/home/flutteruser/flutter/bin:/home/flutteruser/flutter/bin/cache/dart-sdk/bin:${PATH}"

# تفعيل فلاتر للويب فقط وتجاهل الأندرويد والآيفون لتجنب الأخطاء
RUN flutter config --enable-web
RUN flutter precache --web --no-android --no-ios --no-linux --no-windows --no-macos

# إعداد خادم Node.js الخاص بنا
WORKDIR /home/flutteruser/app
COPY --chown=flutteruser:flutteruser package*.json ./
RUN npm install
COPY --chown=flutteruser:flutteruser . .

# فتح البورت وتشغيل السيرفر
EXPOSE 3000
CMD ["npm", "start"]
