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

__ApplicationLibrary GTest_main {
   __LibraryPath = "./";
   __BuildPath = "./temp-build-dir/";
   __LibraryType = __Debug;
   __Source = "./googletest/googletest/src/gtest_main.cc";
   __IncludePath = "./googletest/googletest";
   __LinkerFlags = "-lpthread";
   __CompilerFlags = "-isystem ./googletest/googletest/include -I ./googletest/googletest/include";
   __CompilerFlags = "-pthread";
   __CompilerFlags = "-DGTEST_CREATE_SHARED_LIBRARY=1";
   __DependsOnLibrary = GTest;
}
