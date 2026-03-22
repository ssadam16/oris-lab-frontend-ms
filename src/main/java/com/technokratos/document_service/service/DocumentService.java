package com.technokratos.document_service.service;

import com.technokratos.document_service.dto.DocumentCreatingRequest;
import com.technokratos.document_service.dto.DocumentResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class DocumentService {

    private final RestTemplate restTemplate;

    @Value("${spring.services.document-service.url}")
    private String documentServiceUrl;

    public DocumentResponse createDocument(DocumentCreatingRequest request) {
        request.setUserId(UUID.randomUUID());

        return restTemplate.postForObject(
                documentServiceUrl,
                request,
                DocumentResponse.class
        );
    }

}
