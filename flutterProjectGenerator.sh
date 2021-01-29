read -p "Enter The App Name: "  your_app_name
read -p "Enter the domain: "  domain

flutter create --org $domain $your_app_name

echo "Your Flutter Project is saved in $(pwd)"