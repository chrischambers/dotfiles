djproject() {
    django-admin.py startproject $1 \
        --verbosity=2 \
        --extension="py,txt,rst,json" \
        --template="$django_project_template"
}

djapp() {
    django-admin.py startapp $1 \
        --verbosity=2 \
        --extension="py,txt,rst,json" \
        --template="$django_app_template"
}

djplugapp() {
    django-admin.py startapp $1 \
        --verbosity=2 \
        --extension="py,txt,rst,json" \
        --template="$django_pluggable_app_template"
}
