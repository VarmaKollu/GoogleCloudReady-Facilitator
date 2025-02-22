#!/bin/bash
# Define color variables

BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

BG_BLACK=`tput setab 0`
BG_RED=`tput setab 1`
BG_GREEN=`tput setab 2`
BG_YELLOW=`tput setab 3`
BG_BLUE=`tput setab 4`
BG_MAGENTA=`tput setab 5`
BG_CYAN=`tput setab 6`
BG_WHITE=`tput setab 7`

BOLD=`tput bold`
RESET=`tput sgr0`
#----------------------------------------------------start--------------------------------------------------#

echo "${YELLOW}${BOLD}Starting${RESET}" "${GREEN}${BOLD}Execution${RESET}"

curl -LO https://github.com/varmakollu/CloudSkill/blob/main/APIs%20Explorer%20Cloud%20Storage/demo-image1-copy.png
curl -LO https://github.com/varmakollu/CloudSkill/blob/main/APIs%20Explorer%20Cloud%20Storage/demo-image1.png
curl -LO https://github.com/varmakollu/CloudSkill/blob/main/APIs%20Explorer%20Cloud%20Storage/demo-image2.png


gcloud alpha services api-keys create --display-name="tutorialboy"  
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=tutorialboy") 
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)") 
echo $API_KEY

gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil mb gs://$DEVSHELL_PROJECT_ID-tutorialboy

gsutil cp demo-image1.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image2.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image1-copy.png gs://$DEVSHELL_PROJECT_ID-tutorialboy
