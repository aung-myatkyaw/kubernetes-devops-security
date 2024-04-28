package com.devsecops;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class Properties {

    @Value("${base.url}")
    private String baseURL;

    public String getBaseURL() {
        return baseURL;
    }
}

