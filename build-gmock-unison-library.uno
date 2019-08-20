Unison:SyntaxRevision1709.1;

__ApplicationLibrary GTest {
   __LibraryPath = "./";
   __BuildPath = "./temp-build-dir/";
   __LibraryType = __Debug;
   __Source = "./googletest/googletest/src/gtest-all.cc";
   __IncludePath = "./googletest/googletest";
   __LinkerFlags = "-lpthread";
   __CompilerFlags = "-isystem ./googletest/googletest/include -I ./googletest/googletest/include";
   __CompilerFlags = "-pthread";
   __CompilerFlags = "-DGTEST_CREATE_SHARED_LIBRARY=1";
}

__ApplicationLibrary GMock {
   __LibraryPath = "./";
   __BuildPath = "./temp-build-dir/";
   __LibraryType = __Debug;
   __Source = "./googletest/googletest/src/gtest-all.cc";
   __Source = "./googletest/googlemock/src/gmock-all.cc";
   __IncludePath = "./googletest/googletest";
   __IncludePath = "./googletest/googlemock";
   __LinkerFlags = "-lpthread";
   __CompilerFlags = "-isystem ./googletest/googletest/include -I ./googletest/googletest/include";
   __CompilerFlags = "-isystem ./googletest/googlemock/include -I ./googletest/googlemock/include";
   __CompilerFlags = "-pthread";
   __CompilerFlags = "-DGTEST_CREATE_SHARED_LIBRARY=1";
   __DependsOnLibrary = GTest;
}

__ApplicationLibrary GMock_main {
   __LibraryPath = "./";
   __BuildPath = "./temp-build-dir/";
   __LibraryType = __Debug;
   __Source = "./googletest/googlemock/src/gmock_main.cc";
   __IncludePath = "./googletest/googletest";
   __IncludePath = "./googletest/googlemock";
   __LinkerFlags = "-lpthread";
   __CompilerFlags = "-isystem ./googletest/googletest/include -I ./googletest/googletest/include";
   __CompilerFlags = "-isystem ./googletest/googlemock/include -I ./googletest/googlemock/include";
   __CompilerFlags = "-pthread";
   __CompilerFlags = "-DGTEST_CREATE_SHARED_LIBRARY=1";
   __DependsOnLibrary = GMock;
}
