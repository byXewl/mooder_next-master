# -*- coding: utf-8 -*-
# Generated by Django 1.10.1 on 2016-10-04 19:58
from __future__ import unicode_literals

import archives.models
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('archives', '0005_attachment_post'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='attachment',
            name='post',
        ),
        migrations.RemoveField(
            model_name='attachment',
            name='uploaded_by',
        ),
        migrations.AddField(
            model_name='post',
            name='attachment',
            field=models.FileField(blank=True, upload_to=archives.models.generate_random_filename, verbose_name='附件'),
        ),
        migrations.DeleteModel(
            name='Attachment',
        ),
    ]
