package com.example.microservice1;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.web.bind.annotation.*;

import java.net.InetAddress;
import java.net.UnknownHostException;

@SpringBootApplication
@RestController
public class Microservice1Application extends SpringBootServletInitializer {

    // Needed for WAR deployment in Tomcat
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(Microservice1Application.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(Microservice1Application.class, args);
    }

    @GetMapping("/hello")
    public String hello() throws UnknownHostException {
        String podIp = InetAddress.getLocalHost().getHostAddress();
        return "Hello from Microservice 1, served by Pod IP: " + podIp;
    }
}
