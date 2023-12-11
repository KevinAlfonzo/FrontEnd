import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class ProgramaService {
//PRUEBA
  private apiUrl = 'http://localhost:8086/v1/asignations';

  constructor(private http: HttpClient) { }

  getProgramsList() {
    return this.http.get<any[]>(`${this.apiUrl}/listPrograms`);
  }
}
