package com.technokratos.document_service.controller;

import com.technokratos.document_service.dto.DocumentCreatingRequest;
import com.technokratos.document_service.dto.DocumentResponse;
import com.technokratos.document_service.service.DocumentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.UUID;

@Controller
@RequestMapping("/v1/documents")
@RequiredArgsConstructor
public class DocumentController {

    private final DocumentService documentService;

    @PostMapping
    public String getDocumentsPage(@ModelAttribute("document") @Valid DocumentCreatingRequest request,
                                   BindingResult bindingResult,
                                   RedirectAttributes redirectAttributes) {

        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute(
                    "org.springframework.validation.BindingResult.document",
                    bindingResult
            );
            redirectAttributes.addFlashAttribute("user", request);
            return "redirect:/v1/documents";
        }

        try {
            DocumentResponse response = documentService.createDocument(request);
            redirectAttributes.addFlashAttribute("success", "Документ успешно создан!");

            return "redirect:/v1/documents/%s".formatted(response.documentId());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Не удалось создать документ!");
            redirectAttributes.addFlashAttribute("document", request);

            return "redirect:/v1/documents";
        }
    }

    @GetMapping("/{id}")
    public String getSpecificDocumentPage(@PathVariable UUID id, Model model) {
        model.addAttribute("document", documentService.getById(id));
        return "specific-document";
    }

}