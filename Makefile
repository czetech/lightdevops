CICD_DIR := ./cicd
BUILD_DIR := ./build
BUILD_WEB_DIR := $(BUILD_DIR)/web
BUILD_WEB_CICD_DIR := $(BUILD_WEB_DIR)/cicd

web:
	mkdir -p $(BUILD_DIR)
	rm -rf $(BUILD_WEB_DIR)
	mkdir $(BUILD_WEB_DIR)
	#pandoc --to=html5 --output=$(BUILD_WEB_DIR)/index.html \
	#  --standalone --variable=pagetitle=LightDevOps --self-contained \
	#  --css=docs.css \
	#  --css=https://unpkg.com/github-markdown-css@5.0.0/github-markdown.css \
	#  README.md
	#sed -i 's/<body>/<body class="markdown-body">/' $(BUILD_WEB_DIR)/index.html
	mkdir $(BUILD_WEB_CICD_DIR)
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/default.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BA.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BA.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BA-TA.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BA-TA.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BA-TA-DA.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BA-TA-DA.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BA-TA-DM.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BA-TA-DM.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BA-TM.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BA-TM.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BA-TM-DA.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BA-TM-DA.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BA-TM-DM.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BA-TM-DM.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BM.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BM.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BM-TA.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BM-TA.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BM-TA-DA.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BM-TA-DA.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BM-TA-DM.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BM-TA-DM.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BM-TM.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BM-TM.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BM-TM-DA.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BM-TM-DA.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/
	gomplate -d variant=$(CICD_DIR)/gitlab-kube/variants/BM-TM-DM.yaml \
	  -f $(CICD_DIR)/gitlab-kube/cicd.yaml.tmpl \
	  -o $(BUILD_WEB_CICD_DIR)/gitlab-kube-BM-TM-DM.yaml \
	  -t gitlab-common=$(CICD_DIR)/gitlab-common/ \
	  -t gitlab-kube=$(CICD_DIR)/gitlab-kube/

clean:
	rm -rf $(BUILD_DIR)
