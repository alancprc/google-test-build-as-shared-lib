Unison:SyntaxRevision1709.1;

__ApplicationLibrary GTest {
   __LibraryPath = "./Libraries/GTest";
   __BuildPath = "./Libraries/build-GTest";
   __LibraryType = __Debug;
   __Source = "./googletest/googletest/src/gtest-all.cc";
   __IncludePath = "./googletest/googletest";
   __LinkerFlags = "-lpthread";
   __CompilerFlags = "-isystem ./googletest/googletest/include -I ./googletest/googletest/include";
   __CompilerFlags = "-pthread";
   __CompilerFlags = "-DGTEST_CREATE_SHARED_LIBRARY=1";
}
