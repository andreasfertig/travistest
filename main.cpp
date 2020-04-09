#include <cstdio>

template<typename... Args>
inline void Printf(const char* fmt, Args&&... args)
{
    if constexpr(0 < (sizeof...(args))) {
        printf(fmt, args...);
    } else {
        printf("%s", fmt);
    }
}
//-----------------------------------------------------------------------------


int main()
{
    Printf("Hello", " ", "World")
}
