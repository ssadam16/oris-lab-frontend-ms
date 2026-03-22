package com.technokratos.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;
import org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver;

@Configuration
@EnableWebMvc
@ComponentScan("com.technokratos")
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Вариант 1: Для доступа через /static/**
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(3600)
                .resourceChain(true);

        // Вариант 2: Для доступа через /css/**
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/", "/resources/css/")
                .setCachePeriod(3600);

        // Вариант 3: Универсальный handler для всех статических ресурсов
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("classpath:/static/", "/resources/")
                .setCachePeriod(3600);
    }


    @Bean
    public ViewResolver viewResolver() {
        FreeMarkerViewResolver freeMarkerViewResolver = new FreeMarkerViewResolver();
        freeMarkerViewResolver.setPrefix("");
        freeMarkerViewResolver.setSuffix(".ftlh");
        freeMarkerViewResolver.setContentType("text/html;charset=UTF-8");
        freeMarkerViewResolver.setCache(false);
        return freeMarkerViewResolver;
    }

    @Bean
    public FreeMarkerConfigurer freeMarkerConfigurer() {
        FreeMarkerConfigurer configurer = new FreeMarkerConfigurer();
        configurer.setTemplateLoaderPath("classpath:/templates/");
        configurer.setDefaultEncoding("UTF-8");
        return configurer;
    }

}