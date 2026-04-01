package com.technokratos.config;

import jakarta.servlet.Filter;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.filter.DelegatingFilterProxy;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class FilterRegistrator extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[] {
                WebConfig.class,
                PropertiesConfiguration.class,
                MicroservicesProperties.class
        };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return null; 
    }

    @Override
    protected String[] getServletMappings() {
        return new String[] { "/" };
    }

    @Override
    protected Filter[] getServletFilters() {
        
        CharacterEncodingFilter encodingFilter = new CharacterEncodingFilter();
        encodingFilter.setEncoding("UTF-8");
        encodingFilter.setForceEncoding(true);

        
        DelegatingFilterProxy tokenFilter = new DelegatingFilterProxy("tokenFilter");
        DelegatingFilterProxy restrictionsFilter = new DelegatingFilterProxy("checkRestrictionsFilter");

        
        return new Filter[] { encodingFilter, tokenFilter, restrictionsFilter };
    }

    @Override
    protected void customizeRegistration(jakarta.servlet.ServletRegistration.Dynamic registration) {
        registration.setInitParameter("throwExceptionIfNoHandlerFound", "true");
        registration.setLoadOnStartup(1);
    }
}