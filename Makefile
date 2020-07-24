#
# SYNOPSIS:
#
#   make [all]  - makes everything.
#   make TARGET - makes the given target.
#   make clean  - removes all files generated by make.

# Please tweak the following variable definitions as needed by your
# project, except GTEST_HEADERS, which you can use in your own targets
# but shouldn't modify.

# Points to the root of Google Test, relative to where this file is.
# Remember to tweak this if you move this file.
GTEST_DIR = ./googletest/googletest
GMOCK_DIR = ./googletest/googlemock

# Where to find user code.
USER_DIR = ${GTEST_DIR}/samples

# Kernel version
KERNELVERSION = $(shell uname -r | cut -f1 -d-)

# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include -isystem $(GMOCK_DIR)/include

# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra -pthread

BUILD_BITS := -m64
COMPILE_GTEST_AS_LIB = -DGTEST_CREATE_SHARED_LIBRARY=1
GTEST_CXXFLAGS += $(BUILD_BITS) -fPIC -Wwrite-strings -fnon-call-exceptions \
				  -fcheck-new -Werror -Wreturn-type $(COMPILE_GTEST_AS_LIB)

# U4
ifneq ($(shell readlink /opt/ltx/ltx_os | grep U4),)
	BUILD_BITS := -m32
	CXXFLAGS += -std=c++0x -DGTEST_LANG_CXX11=0

	# CentOS 7 with compat-gcc-44-c++ installed
	ifneq ($(wildcard /usr/bin/g++44),)
		CXX = /usr/bin/g++44
	endif
endif

ifneq ($(shell man $(CXX) | grep c++11), )
	CXXFLAGS += -std=c++11
endif

# No UNIQUE symbol in order to reload properly.
UNIQUE = $(shell man $(CXX) | grep no-gnu-unique)
ifneq ("$(UNIQUE)", "")
	GTEST_CXXFLAGS += -fno-gnu-unique
endif

# Flags passed to the Linker.
# Flags to link gtest lib
LDFLAGS += $(BUILD_BITS) -shared -Wl,-rpath='$$ORIGIN' -pthread

# Flags to compile and link sample1_unitest
USE_GTEST_AS_LIB = -DGTEST_LINKED_SHARED_LIBRARY=1
USER_CXXfLAGS += $(BUILD_BITS) $(USE_GTEST_AS_LIB)
USER_LDFLAGS += $(BUILD_BITS) -Wl,-rpath='$$ORIGIN' -pthread

# All Google Test headers.  Usually you shouldn't change this
# definition.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h

# House-keeping build targets.
all : libgtest.so libgtest_main.so libgmock.so libgmock_main.so \
	sample1_unittest run_sample

clean :
	rm -f sample1_unittest *.so  *.o

# Usually you shouldn't tweak such internal variables, indicated by a
# trailing _.
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)
GMOCK_SRCS_ = $(GMOCK_DIR)/src/*.cc                      $(GMOCK_HEADERS)

# For simplicity and to avoid depending on Google Test's
# implementation details, the dependencies specified below are
# conservative and not optimized.  This is fine as Google Test
# compiles fast and for ordinary users its source rarely changes.
gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) $(GTEST_CXXFLAGS) \
		-c $(GTEST_DIR)/src/gtest-all.cc

gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) $(GTEST_CXXFLAGS) \
		-c $(GTEST_DIR)/src/gtest_main.cc

gmock-all.o : $(GMOCK_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) -I$(GMOCK_DIR) $(CXXFLAGS) \
		$(GTEST_CXXFLAGS) -c $(GMOCK_DIR)/src/gmock-all.cc

gmock_main.o : $(GMOCK_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) -I$(GMOCK_DIR) $(CXXFLAGS) \
		$(GTEST_CXXFLAGS) -c $(GMOCK_DIR)/src/gmock_main.cc

libgtest.so : gtest-all.o
	$(CXX) -o $@ $^ $(LDFLAGS)

libgtest_main.so : gtest_main.o
	$(CXX) -o $@ $^ $(LDFLAGS) -L. -lgtest

libgmock.so : gmock-all.o
	$(CXX) -o $@ $^ $(LDFLAGS) -L. -lgtest

libgmock_main.so : gmock_main.o
	$(CXX) -o $@ $^ $(LDFLAGS) -L. -lgtest -lgmock

sample1.o : $(USER_DIR)/sample1.cc $(USER_DIR)/sample1.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(USER_CXXfLAGS) -c $(USER_DIR)/sample1.cc

sample1_unittest.o : $(USER_DIR)/sample1_unittest.cc \
                     $(USER_DIR)/sample1.h $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(USER_CXXfLAGS) \
		-c $(USER_DIR)/sample1_unittest.cc

sample1_unittest : sample1.o sample1_unittest.o 
	$(CXX) $(CPPFLAGS) $(USER_LDFLAGS) $^ -o $@ -L. -lgmock_main -lgmock -lgtest

run_sample : 
	LD_LIBRARY_PATH=. ./sample1_unittest
