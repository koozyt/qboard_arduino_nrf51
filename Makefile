PACKAGE_JSON_NRF51=package_koozyt_qboard_index.json
ARCHIVE_NRF51=qboard_nrf51.tar.bz2
UPLOADER_NRF51=../koozyt_uploader_nrf/build/package_qboard_uploader_nrf51.json

all: build/${PACKAGE_JSON_NRF51}

build/${ARCHIVE_NRF51}:
	tar cjf build/${ARCHIVE_NRF51} nrf51

build/shsum-nrf51: build/${ARCHIVE_NRF51}
	cd build && shasum -a 256 ${ARCHIVE_NRF51} | cut -d' ' -f1 > shsum-nrf51

build/size-nrf51: build/${ARCHIVE_NRF51}
	cd build && ls -l ${ARCHIVE_NRF51} | cut -d' ' -f5 > size-nrf51

build/${PACKAGE_JSON_NRF51}: packaging/${PACKAGE_JSON_NRF51} build/shsum-nrf51 build/size-nrf51 ${UPLOADER_NRF51}
	sed -e "s/%%CHECKSUM%%/`cat build/shsum-nrf51`/" -e "s/%%SIZE%%/`cat build/size-nrf51`/" < packaging/${PACKAGE_JSON_NRF51} | awk -v "f1=$$(< ${UPLOADER_NRF51})" '{gsub("%%TOOLS%%", f1); print}' | json_pp > build/${PACKAGE_JSON_NRF51}
