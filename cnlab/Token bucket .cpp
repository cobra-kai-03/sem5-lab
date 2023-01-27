#include <bits/stdc++.h>
#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif
#include <iostream>
#include <cstdlib>
#include <chrono>
#include <thread>

class TokenBucket {
    public:
        TokenBucket(int tokens, int time_unit, void (*forward_callback)(int), void (*drop_callback)(int)) {
            this->tokens = tokens;
            this->time_unit = time_unit;
            this->forward_callback = forward_callback;
            this->drop_callback = drop_callback;
            this->bucket = tokens;
            this->last_check = std::chrono::system_clock::now();
        }

        void handle(int packet) {
            auto current = std::chrono::system_clock::now();
            auto time_passed = std::chrono::duration_cast<std::chrono::milliseconds>(current - this->last_check).count();
            this->last_check = current;

            this->bucket = this->bucket + (time_passed * (this->tokens / this->time_unit));

            if (this->bucket > this->tokens) {
                this->bucket = this->tokens;
            }

            if (this->bucket < 1) {
                this->drop_callback(packet);
            } else {
                this->bucket = this->bucket - 1;
                this->forward_callback(packet);
            }
        }

    private:
        int tokens;
        int time_unit;
        void (*forward_callback)(int);
        void (*drop_callback)(int);
        int bucket;
        std::chrono::time_point<std::chrono::system_clock> last_check;
};

void forward(int packet) {
    std::cout << "Packet Forwarded: " << packet << std::endl;
}

void drop(int packet) {
    std::cout << "Packet Dropped: " << packet << std::endl;
}

int main() {
    TokenBucket throttle(1, 1, forward, drop);

    int packet = 0;

    while (true) {
        Sleep(1000);
    throttle.handle(packet);
    packet++;

    }
}
